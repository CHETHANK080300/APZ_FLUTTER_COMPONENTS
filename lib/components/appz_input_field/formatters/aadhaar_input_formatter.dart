import 'package:flutter/services.dart';

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the new text and remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If the new text is longer than 12 digits, truncate it
    if (newText.length > 12) {
      newText = newText.substring(0, 12);
    }

    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      formattedText.write(newText[i]);
      if ((i == 3 || i == 7) && i != newText.length - 1) {
        formattedText.write(' '); // Add space after 4th and 8th digit
      }
    }

    int newSelectionOffset = newValue.selection.end;
    int spacesBeforeCursor = 0;
    for(int i=0; i< newValue.selection.end && i < formattedText.length; i++){
        if(formattedText.toString()[i] == ' '){
            spacesBeforeCursor++;
        }
    }
    newSelectionOffset = newValue.selection.end + spacesBeforeCursor - (newValue.text.substring(0, newValue.selection.end).split(' ').length -1);

    // Ensure selection offset is within bounds
    if (newSelectionOffset > formattedText.length) {
      newSelectionOffset = formattedText.length;
    }


    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
  }
}
