#!/bin/bash

echo "🔐 Génération du keystore pour VirtualMG"

# Demander les mots de passe
read -sp "Mot de passe du keystore: " KEYSTORE_PASS
echo
read -sp "Confirmer mot de passe: " KEYSTORE_PASS_CONFIRM
echo

if [ "$KEYSTORE_PASS" != "$KEYSTORE_PASS_CONFIRM" ]; then
    echo -e "\033[0;31m❌ Les mots de passe ne correspondent pas\033[0m"
    exit 1
fi

read -sp "Mot de passe de la clé: " KEY_PASS
echo
read -sp "Confirmer mot de passe de la clé: " KEY_PASS_CONFIRM
echo

if [ "$KEY_PASS" != "$KEY_PASS_CONFIRM" ]; then
    echo -e "\033[0;31m❌ Les mots de passe ne correspondent pas\033[0m"
    exit 1
fi

# Informations du certificat
read -p "Prénom et Nom: " FULL_NAME
read -p "Unité organisationnelle: " OU
read -p "Organisation: " ORG
read -p "Ville: " CITY
read -p "Région: " STATE
read -p "Code pays (2 lettres): " COUNTRY

# Générer le keystore
keytool -genkey -v     -keystore keystore.jks     -alias my-key-alias     -keyalg RSA     -keysize 2048     -validity 10000     -storepass "$KEYSTORE_PASS"     -keypass "$KEY_PASS"     -dname "CN=$FULL_NAME, OU=$OU, O=$ORG, L=$CITY, ST=$STATE, C=$COUNTRY"

# Convertir en base64
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    base64 -w 0 keystore.jks > keystore_base64.txt
    echo -e "\033[0;32m✅ Keystore généré : keystore.jks\033[0m"
    echo -e "\033[0;32m✅ Base64 sauvegardé : keystore_base64.txt\033[0m"
    echo -e "\033[1;33m📋 Contenu du base64 (à copier dans GitHub secret KEYSTORE_BASE64):\033[0m"
    cat keystore_base64.txt
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('keystore.jks')) | Out-File -FilePath keystore_base64.txt"
    echo -e "\033[0;32m✅ Keystore généré : keystore.jks\033[0m"
    echo -e "\033[0;32m✅ Base64 sauvegardé : keystore_base64.txt\033[0m"
fi

# Sauvegarder les infos
cat > keystore-info.txt << EOL
Keystore Information for VirtualMG
==================================
Alias: my-key-alias
Keystore Password: $KEYSTORE_PASS
Key Password: $KEY_PASS
Generated: $(date)

IMPORTANT: Gardez ces informations en sécurité !
EOL

echo -e "\033[0;32m✅ Informations sauvegardées dans keystore-info.txt\033[0m"
echo -e "\033[0;31m⚠️  NE PAS COMMITTER ces fichiers ! Ajoutez-les à .gitignore\033[0m"
