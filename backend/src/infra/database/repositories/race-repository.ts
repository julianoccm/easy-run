import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Race } from 'src/application/entities/race.model';
import { Between, LessThan, Repository } from 'typeorm';

@Injectable()
export default class RaceRepository {
  constructor(
    @InjectRepository(Race) private readonly raceRepository: Repository<Race>,
  ) {}

  async save(race: Race): Promise<Race> {
    race.id = null;
    return await this.raceRepository.save(race);
  }

  async update(race: Race): Promise<Race> {
    return await this.raceRepository.save(race);
  }

  async findById(id: number): Promise<Race> {
    return await this.raceRepository.findOne({
      where: {
        id: id,
      },
    });
  }

  async findAllUserRaces(userId: number): Promise<Race[]> {
    return await this.raceRepository.find({
      where: {
        user: {
          id: userId,
        },
      },
    });
  }

  async findByDate(initialDate: Date, finalDate: Date, userId: number): Promise<Race[]> {
    return await this.raceRepository.find({
      where: {
        date: Between(initialDate, finalDate),
        user: {
          id: userId
        }
      },
    });
  }

  async findAll(): Promise<Race[]> {
    return await this.raceRepository.find();
  }

  async delete(id: number) {
    await this.raceRepository.delete({
      id: id,
    });
  }
}
