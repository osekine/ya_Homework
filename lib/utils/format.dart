String getFormattedDate(DateTime date) {
  final List<String> months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря'
  ];
  return '${date.day} ${months[date.month.toInt()]} ${date.year}';
}
