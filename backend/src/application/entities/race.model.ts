import { Entity, Column, PrimaryGeneratedColumn, OneToMany, ManyToOne, JoinColumn } from 'typeorm';
import { LocationCoords } from './location-coords.model';
import { User } from './user.model';

interface IRace {
  id: number;
  user: User;
  kilometers: number;
  time: number;
  calories: number;
  date: Date;
  initialTime: number;
  finalTime: number;
  coords: LocationCoords[];
}

@Entity()
export class Race implements IRace {
  
  @PrimaryGeneratedColumn()
  id: number;
  
  @Column({nullable: false, type: 'double'})
  kilometers: number;
  
  @Column({nullable: false})
  time: number;
  
  @Column({nullable: false, type: 'double'})
  calories: number;
  
  @Column({nullable: false})
  date: Date;

  @Column({nullable: false, type: 'bigint'})
  initialTime: number;

  @Column({nullable: false, type: 'bigint'})
  finalTime: number;

  @ManyToOne(type => User, user => user.id, { cascade : true })
  user: User;
  
  @OneToMany(type => LocationCoords, location => location.race, { cascade : true, eager: true })
  coords: LocationCoords[];
  
  constructor(id: number, user: User, kilometers: number, time: number, calories: number, date: Date, initialTime: number, finalTime: number, coords: LocationCoords[]) {
    this.id = id;
    this.user = user;
    this.kilometers = kilometers;
    this.time = time;
    this.calories = calories;
    this.date = date;
    this.initialTime = initialTime;
    this.finalTime = finalTime;
    this.coords = coords;
  }
}
