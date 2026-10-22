# મેથાણ યુવક મિત્ર મંડળ - Android APK (GitHub thi)

Computer par kai install karvanu nathi. GitHub na cloud ma APK bane che.

## Steps
1. https://github.com par login karo. Upar **+** > **New repository**. Name: `methan-app`. **Create repository** dabavo.
2. Navi repository ma **uploading an existing file** link dabavo.
3. Aa folder ni andar thi aa 3 vastu drag karo: **`lib`** folder, **`pubspec.yaml`** file, ane **`.github`** folder.
   (Jo `.github` folder dekhay nahi ke upload na thay, to Step 4 karo, nahitar Step 4 skip karo.)
   Niche **Commit changes** dabavo.
4. (Fakt jarur hoy to) **Add file > Create new file** > nam ma lakho: `.github/workflows/build-apk.yml` (slash lakhso etle folder jate banse). Aa folder ni `.github/workflows/build-apk.yml` file no badho text copy karine paste karo ane **Commit changes** dabavo.
5. Upar **Actions** tab kholo. "Build APK" chalu thashe (5 thi 10 minute). Lilu ✅ aave tyan sudhi rah jovo.
6. Te run par click karo. Niche **Artifacts** ma `Methan-Yuvak-Mitra-Mandal-APK` download karo. Zip extract karo, tema `app-release.apk` male.
7. APK phone ma moklo ane tap karine install karo. Android "Unknown source / Install unknown apps" puchhe to Allow karo.

Jo Actions ma lal ❌ aave, to e step khola ane error nu lakhan mane moklo.
