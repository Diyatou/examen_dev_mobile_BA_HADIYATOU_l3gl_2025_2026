import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';

//Ce bouton est intelligent : il gère le chargement, les icônes et deux styles (plein ou contour).

  class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? color;

  const CustomButton({
  super.key,
  required this.text,
  this.onPressed,
  this.isLoading = false,
  this.isOutlined = false,
  this.icon,
  this.width,
  this.height,
  this.color,
  });

  @override
  Widget build(BuildContext context) {
  final buttonColor = color ?? AppColors.primary;

  // Contenu interne du bouton (Texte ou Chargement)
  Widget buttonContent = isLoading
  ? const SizedBox(
  height: 20,
  width: 20,
  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
  )
      : Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
  Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  ],
  );

  return SizedBox(
  width: width ?? double.infinity,
  height: height ?? 50,
  child: isOutlined
  ? OutlinedButton(
  onPressed: isLoading ? null : onPressed,
  style: OutlinedButton.styleFrom(
  side: BorderSide(color: buttonColor),
  foregroundColor: buttonColor,
  ),
  child: buttonContent,
  )
      : ElevatedButton(
  onPressed: isLoading ? null : onPressed,
  style: ElevatedButton.styleFrom(
  backgroundColor: buttonColor,
  foregroundColor: Colors.white,
  ),
  child: buttonContent,
  ),
  );
  }
  }