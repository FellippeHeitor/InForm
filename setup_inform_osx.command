cd "$(dirname "$0")"
# InForm for QB64/QB64PE - Setup script

### Perform CLEAN function
rm -fr InForm/UiEditor InForm/UiEditor_start.command InForm/UiEditorPreview InForm/UiEditorPreview_start.command


### Install if QB64 is found
if [ -e "./qb64" ]; then
	echo "Compiling InForm..."
	./qb64 -x -p ./InForm/UiEditor.bas -o ./InForm/UiEditor
	./qb64 -x -p ./InForm/UiEditorPreview.bas -s:exewithsource=true -o ./InForm/UiEditorPreview
	cd InForm
	if [ -e "./UiEditor" ]; then
		echo "Running InForm Designer..."
		./UiEditor &
		echo
		echo "Thank you for choosing InForm for QB64."  
		osascript -e 'tell application "Terminal" to close (every window whose name contains "UiEditor_start.command")' &
		osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
		exit 0
	else
		echo "Compilation failed."
		echo "Make sure you unpacked all files in QB64's folder, preserving the directory structure, and also that you have QB64 to use InForm."
		exit 1
	fi  

### Install if Q64PE is found
elif [ -e "./qb64pe" ]; then
	echo "Compiling InForm..."
	./qb64pe -x -p ./InForm/UiEditor.bas -o ./InForm/UiEditor
	./qb64pe -x -p ./InForm/UiEditorPreview.bas -s:exewithsource=true -o ./InForm/UiEditorPreview
	cd InForm
	if [ -e "./UiEditor" ]; then
		echo "Running InForm Designer..."
		./UiEditor &
		echo
		echo "Thank you for choosing InForm for QB64PE."  
		osascript -e 'tell application "Terminal" to close (every window whose name contains "UiEditor_start.command")' &
		osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
		exit 0
	else
		echo "Compilation failed."
		echo "Make sure you unpacked all files in QB64PE's folder, preserving the directory structure, and also that you have QB64PE to use InForm."
		exit 1
	fi  

### If neither QB64 or QB64PE is found, message and error out.
else
	echo "Compilation failed."
	echo "Make sure you have either QB64 or QB64PE installed to use InForm."
	exit 1
fi

exit 0
