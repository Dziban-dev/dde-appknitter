#!/bin/bash
#GETTING SYSTEM LANGUAGE
LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
#TRANSLATION VARIABLES
#Titles
#---Name Request Window
readonly NAME_REQUEST_TIL_en="New .desktop File's Name"
readonly NAME_REQUEST_TIL_es="Nombre Para .desktop Nuevo"
readonly EXEC_REQUEST_TIL_en="Select Executable File"
readonly EXEC_REQUEST_TIL_es="Selecciona Un Archivo Ejecutable"
readonly ICON_REQUEST_TIL_en="Select Icon File (.svg)"
readonly ICON_REQUEST_TIL_es="Selecciona Archivo para Icono (.svg)"
readonly CATEG_REQUEST_TIL_en="Select Launcher Catergory"
readonly CATEG_REQUEST_TIL_es="Selecciona un Catergoria Para El Lanzador"
readonly KEYW_REQUEST_TIL_en="Write Keywords"
readonly KEYW_REQUEST_TIL_es="Escribe Palabras Clave"
#Dialosgs
readonly NAME_REQUEST_DLG_en="Choose a name for your '.desktop' file.
Press cancel to quit."
readonly NAME_REQUEST_DLG_es="Escribe un nombre para el archivo '.desktop'.
Presiona Cancelar para salir."
readonly NAME_REQUEST2_DLG_en="The name entry must not be empty!
Please, choose a name for your '.desktop' file.

Or press cancel to quit."
readonly NAME_REQUEST2_DLG_es="La entrada no puede ser vacía!
Porfavor, selecciona un nombre para el arhivo '.desktop'.

O Presiona Cancelar para salir."

readonly CATEG_REQUEST_DLG_en="Launcher Category"
readonly CATEG_REQUEST_DLG_es="Categoria del lanzador"
readonly CATEG_REQUEST_DLG2_en="Choose one option"
readonly CATEG_REQUEST_DLG2_es="Elige Una Opción"
readonly CATEG_REQUEST_COMBO_en="Internet|Chat|Music|Video|Graphics|Office|Development|System|Others"
readonly CATEG_REQUEST_COMBO_es="Internet|Chat|Music|Video|Graphics|Office|Development|System|Others"
readonly KEYW_REQUEST_DLG_en="Write 'keywords' for the application."
readonly KEYW_REQUEST_DLG_es="Escribe 'palabras clave' para la aplicación."
readonly KEYW_REQUEST_DLG2_en="example;of;how;to;type;keywords;here"
readonly KEYW_REQUEST_DLG2_es="ejemplo;de;como;escribir;las;palabras;clave"
###############################################################
#----NAME
eval "title=\$NAME_REQUEST_TIL_${LANG}"
eval "text=\$NAME_REQUEST_DLG_${LANG}"
eval "text2=\$NAME_REQUEST2_DLG_${LANG}"
get_name(){
    zenity --entry --width=300 --title="$title" --text="$text"
}
name=$(get_name) || exit
while [ "$(expr match "$name" '.')" -lt "1" ]; do
    zenity --entry --width=300 --title="$title" --text="$text2"
    name=$(get_name) || exit
done
#----EXEC
eval "title=\$EXEC_REQUEST_TIL_${LANG}"
exec=$(zenity --title="$title" --file-selection)
#----ICON
eval "title=\$ICON_REQUEST_TIL_${LANG}"
icon=$(zenity --title="$title" --file-selection)
#----CATEG
eval "title=\$CATEG_REQUEST_TIL_${LANG}"
eval "text=\$CATEG_REQUEST_DLG_${LANG}"
eval "text2=\$CATEG_REQUEST_DLG2_${LANG}"
eval "combo=\$CATEG_REQUEST_COMBO_${LANG}"
categ=$(zenity --forms --width=350 --title="$title" --text="$text" --add-combo="$text2" --combo-values="$combo")
#----KEYW
eval "title=\$KEYW_REQUEST_TIL_${LANG}"
eval "text=\$KEYW_REQUEST_DLG_${LANG}"
eval "text2=\$KEYW_REQUEST_DLG2_${LANG}"
keyw=$(zenity --entry --width=350 --title="$title" --entry-text="$text2" --text="$text")
#
if [ ! -d "$HOME/.local/share/applications" ] 
then
    mkdir ~/.local/share/applications
fi
cat > ~/.local/share/applications/${name}.desktop<<EOT
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=$name
Exec=$exec
Icon=$icon
Categories=${categ};
Keywords=${keyw};
EOT
cat /var/run/myProcess.pid | sudo xargs kill -9
chmod +x ~/.local/share/applications/${name}.desktop
chmod +x $exec
dedit ~/.local/share/applications/${name}.desktop

