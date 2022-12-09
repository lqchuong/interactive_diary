part of 'nartus_button.dart';

class _NartusSecondaryButton extends StatelessWidget {
  final String? label;
  final String? icon;
  final String? iconSemanticLabel;
  final IconPosition iconPosition;
  final VoidCallback? onPressed;
  final SizeType sizeType;

  const _NartusSecondaryButton(
      {Key? key,
      this.label,
      this.icon,
      this.iconSemanticLabel,
      this.onPressed,
      this.iconPosition = IconPosition.left,
      this.sizeType = SizeType.large})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (icon != null && label != null) {
      return Semantics(
        explicitChildNodes: false,
        excludeSemantics: true,
        label: iconPosition == IconPosition.left
            ? '$iconSemanticLabel, $label'
            : '$label, $iconSemanticLabel',
        button: true,
        enabled: onPressed != null,
        onTap: onPressed,
        child: OutlinedButton(
          onPressed: onPressed,
          child: _ButtonContent(
            label: label!,
            icon: icon!,
            buttonType: ButtonType.secondary,
            isEnable: onPressed != null,
            iconPosition: iconPosition,
          ),
        ),
      );
    } else if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        style: sizeType == SizeType.large ? null : _buttonStyleTextSmall,
        child: Text(
          label!,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Semantics(
        explicitChildNodes: false,
        excludeSemantics: true,
        label: iconSemanticLabel,
        button: true,
        enabled: onPressed != null,
        onTap: onPressed,
        child: OutlinedButton(
            onPressed: onPressed,
            style: sizeType == SizeType.large
                ? _iconOnlyButtonStyleLarge
                : _iconOnlyButtonStyleSmall,
            child: SvgPicture.asset(
              icon!,
              width: NartusDimens.padding20,
              height: NartusDimens.padding20,
              color: onPressed == null
                  ? NartusColor.grey.withOpacity(0.5)
                  : NartusColor.primary,
              semanticsLabel: iconSemanticLabel,
            )),
      );
    }
  }
}
