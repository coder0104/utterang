class BoatModel {
  final String boatname;
  final String boatloca;
  final int maxperson;

  BoatModel.fromJson(Map<String, dynamic> json)
      : boatname = json['fsboNm'],
        boatloca = json['fshNtNm'],
        maxperson = int.tryParse(json['maxPsrNum'].replaceAll('명', '')) ?? 0;
}
