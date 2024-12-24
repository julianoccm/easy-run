class UserInfoReturn {
  final int meta;
  final int metaAtingida;
  final double porcentagemMeta;
  final double calorias;
  final double distanciaTotal;
  final int tempo;

  const UserInfoReturn(
      {required this.meta,
      required this.metaAtingida,
      required this.calorias,
      required this.distanciaTotal,
      required this.tempo,
      required this.porcentagemMeta});

  factory UserInfoReturn.fromJson(Map<String, dynamic> json) {
    int meta = json['meta'];
    int metaAtingida = json['metaAtingida'];

    double porcentagemMeta = 0.0;
    if(json['porcentagemMeta'] is int) {
      porcentagemMeta = double.parse(json['porcentagemMeta'].toString());
    } else {
      porcentagemMeta = json['porcentagemMeta'];
    }

    double calorias = 0.0;

    if(json['calorias'] is! double) {
      calorias = double.parse(json['calorias'].toString());
    } else {
      calorias = json['calorias'];
    }
    
    double distanciaTotal = 0.0;

    if(json['distanciaTotal'] is double) {
      distanciaTotal = json['distanciaTotal'];
    } else {
      distanciaTotal = double.parse(json['distanciaTotal'].toString());
    }

    int tempo = json['tempo'];

    return UserInfoReturn(
        meta: meta,
        tempo: tempo,
        calorias: calorias,
        distanciaTotal: distanciaTotal,
        metaAtingida: metaAtingida,
        porcentagemMeta: porcentagemMeta);
  }
}
