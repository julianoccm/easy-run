interface IUserInfo {
  meta: number,
  metaAtingida: number,
  porcentagemMeta: number,
  calorias: number,
  distanciaTotal: number,
  tempo: number
}

export class UserInfo implements IUserInfo {
  meta: number;
  metaAtingida: number;
  calorias: number;
  porcentagemMeta: number;
  distanciaTotal: number;
  tempo: number;

  constructor(meta: number,
    metaAtingida: number,
    porcentagemMeta: number,
    calorias: number,
    distanciaTotal: number,
    tempo: number
  ) {
    this.meta = meta;
    this.metaAtingida = metaAtingida;
    this.porcentagemMeta = porcentagemMeta;
    this.calorias = calorias;
    this.distanciaTotal = distanciaTotal;
    this.tempo = tempo;
  }
}
