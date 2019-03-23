final List<CardViewModel> demoCards = [
  new CardViewModel(
    backdropAssetPath: 'assets/img1.jpg',
    address: '10TH STREET',
    minHeightInFeet: 2,
    maxHeightInFeet: 3,
    tempInDegrees: 65.1,
    weatherType: "Mostly Cloudy",
    windSpeedInMph: 11.2,
    cardinalDirection: "ENE"
  ),
  new CardViewModel(
    backdropAssetPath: 'assets/img2.jpg',
    address: '20TH STREET',
    minHeightInFeet: 3,
    maxHeightInFeet: 5,
    tempInDegrees: 45.1,
    weatherType: "Mostly Sunny",
    windSpeedInMph: 13.2,
    cardinalDirection: "NE"
  ),
  new CardViewModel(
    backdropAssetPath: 'assets/img3.jpg',
    address: '30TH STREET',
    minHeightInFeet: 1,
    maxHeightInFeet: 6,
    tempInDegrees: 55.1,
    weatherType: "Rainy",
    windSpeedInMph: 117.2,
    cardinalDirection: "N"
  ),
];
class CardViewModel {
  final String backdropAssetPath;
  final address;
  final int minHeightInFeet;
  final int maxHeightInFeet;
  final double tempInDegrees;
  final String weatherType;
  final double windSpeedInMph;
  final String cardinalDirection;
  CardViewModel({
    this.backdropAssetPath,
    this.address,
    this.minHeightInFeet,
    this.maxHeightInFeet,
    this.tempInDegrees,
    this.weatherType,
    this.windSpeedInMph,
    this.cardinalDirection
  });
}