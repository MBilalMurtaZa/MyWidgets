enum MyToastGravity {
  top(value: 'TOP'),
  bottom(value: 'BOTTOM'),
  center(value: 'CENTER'),
  topLeft(value:'TOP_LEFT' ),
  topRight(value:'TOP_RIGHT' ),
  bottomLeft(value:'BOTTOM_LEFT' ),
  bottomRight(value:'BOTTOM_RIGHT' ),
  centerLeft(value: 'CENTER_LEFT'),
  centerRight(value: 'CENTER_RIGHT'),
  snackBar(value: 'SNACKBAR'),
  none(value: 'NONE');

  final String value;
  const MyToastGravity({required this.value});
}
