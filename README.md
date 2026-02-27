# VirtualMG - Android WebView

Cette application est une WebView qui affiche le site : https://pred46.onrender.com

## Configuration GitHub Secrets

Ajoutez ces secrets dans votre dépôt GitHub :

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Keystore encodé en base64 |
| `KEYSTORE_PASSWORD` | Mot de passe du keystore |
| `KEY_PASSWORD` | Mot de passe de la clé |
| `KEY_ALIAS` | Alias de la clé (`my-key-alias`) |

## Générer le keystore

```bash
# Générer le keystore
keytool -genkey -v -keystore keystore.jks -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

# Convertir en base64 (Linux/Mac)
base64 -w 0 keystore.jks > keystore_base64.txt

# Sur Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("keystore.jks")) > keystore_base64.txt
```

## Structure du projet

```
VirtualMG/
├── .github/workflows/    # Configuration GitHub Actions
├── android-app/          # Code source Android
└── config/               # Fichiers de configuration
```

## Build automatique

L'APK est automatiquement générée à chaque push sur la branche `main`.
Les artefacts sont disponibles dans l'onglet "Actions" de GitHub.
