default:
	dart run build_runner build --delete-conflicting-outputs

l10n:
	flutter gen-l10n
	dart run build_runner build
