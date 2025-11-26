import 'package:flutter/material.dart';

class SafeBottomWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  
  const SafeBottomWidget({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom > 0 
            ? MediaQuery.of(context).padding.bottom 
            : 16.0,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}

class SafeBottomNavigationBar extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  
  const SafeBottomNavigationBar({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
