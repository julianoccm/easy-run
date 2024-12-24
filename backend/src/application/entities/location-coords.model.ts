import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Race } from './race.model';

interface ILocationCoords {
  id: number;
  race: Race;
  latitude: number;
  longitude: number;
}

@Entity()
export class LocationCoords implements ILocationCoords {

  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(type => Race, race => race.id)
  race: Race;

  @Column({nullable: false, type: 'double'})
  latitude: number;

  @Column({nullable: false, type: 'double'})
  longitude: number;

  constructor(id: number, race: Race, latitude: number, longitude: number) {
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.race = race;
  }
}