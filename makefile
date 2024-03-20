default:
	dart run build_runner build --delete-conflicting-outputs

generate-localization:
	flutter gen-l10n
	dart run build_runner build
