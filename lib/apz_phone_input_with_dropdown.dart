import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonecodes/phonecodes.dart';

import 'common/country_model.dart';

class ApzPhoneInputWithDropdown extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? initialPhoneCode;
  final String? initialValue;
  final String? label;
  final String? hintText;
  final bool isMandatory;

  const ApzPhoneInputWithDropdown({
    super.key,
    this.onChanged,
    this.initialPhoneCode,
    this.label, 
    this.hintText,
    this.initialValue,
    this.isMandatory = false
  });

  @override
  State<ApzPhoneInputWithDropdown> createState() => _PhoneInputWithDropdownState();
}

class _PhoneInputWithDropdownState extends State<ApzPhoneInputWithDropdown> {
  late TextEditingController _controller = TextEditingController();
  final _layerLink = LayerLink();
  final _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;

  late List<CountryModel> fullCountryList;
  late List<CountryModel> filteredCountryList;
  late CountryModel _selectedCountry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    fullCountryList = Country.values.map((country) {
      return CountryModel(
        isoCode: country.code,
        name: country.name,
        phoneCode: country.dialCode.replaceAll('+', ''),
        flag: country.flag,
      );
    }).toList();

    _selectedCountry = fullCountryList.firstWhere(
      (c) => c.phoneCode == (widget.initialPhoneCode ?? '91'),
      orElse: () => fullCountryList.first,
    );

    filteredCountryList = fullCountryList;
  }

  void _showCountryDropdown() {
    _searchController.clear();
    filteredCountryList = fullCountryList;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountryList = fullCountryList
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.phoneCode.contains(query))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height, // flush right under the field
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search country',
                    ),
                    onChanged: _filterCountries,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredCountryList.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountryList[index];
                      return ListTile(
                        leading: Text(country.flag, style: const TextStyle(fontSize: 20)),
                        title: Text(country.name),
                        trailing: Text('+${country.phoneCode}'),
                        onTap: () {
                          setState(() {
                            _selectedCountry = country;
                          });
                          _removeOverlay();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
              children: widget.isMandatory
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (_overlayEntry == null) {
                      _showCountryDropdown();
                    } else {
                      _removeOverlay();
                    }
                  },
                  child: Row(
                    children: [
                      Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 4),
                      Text('+${_selectedCountry.phoneCode}'),
                      const Icon(Icons.arrow_drop_down_rounded),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Phone Number"
                      //hintText: local.enterPhone,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    onChanged: (value) {
                      final fullNumber = '+${_selectedCountry.phoneCode} $value';
                      widget.onChanged?.call(fullNumber);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}