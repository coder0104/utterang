class BoatModel {
  final String boatname, boatloca, maxperson;

  BoatModel.fromJson(Map<String, dynamic> json)
    :boatname = json['fsboNm'],
    boatloca = json['shpmHangNm'],
    maxperson = json['maxPsrNum'];
}
