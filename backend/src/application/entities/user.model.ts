import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { Race } from './race.model';

interface IUser {
  id: number;
  name: string;
  email: string;
  password: string;
  target: number;
  peso: number;
  races: Race[];
}

@Entity()
export class User implements IUser {

  @PrimaryGeneratedColumn()
  id: number;

  @Column({nullable: false})
  name: string;

  @Column({nullable: false})
  email: string;

  @Column({nullable: false})
  password: string;

  @Column({nullable: false})
  target: number;

  @Column({nullable: false, type: 'double'})
  peso: number;

  @OneToMany(type => Race, race => race.user)
  races: Race[];


  constructor(id: number, name: string, email: string, password: string, target: number, races: Race[], peso: number) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
    this.target = target;
    this.peso = peso;
    this.races = races;
  }
}
