sealed class AppSectionIntent {}

class AppSectionIndexChangedIntent extends AppSectionIntent {
  final int index;
  AppSectionIndexChangedIntent(this.index);
}
