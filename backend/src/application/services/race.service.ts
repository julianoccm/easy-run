import { Race } from '../entities/race.model';
import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import RaceRepository from 'src/infra/database/repositories/race-repository';
import { UserInfo } from '../entities/user-info.model';
import { UserService } from './user.service';
import { LocationCoords } from '../entities/location-coords.model';
import LocationCoordsRepository from 'src/infra/database/repositories/location-coord-repository';
import { User } from '../entities/user.model';

@Injectable()
export class RaceService {
  private readonly logger = new Logger(RaceService.name);

  constructor(private raceRepository: RaceRepository, private userService: UserService, private locationCoordsRepository: LocationCoordsRepository) {}

  async save(race): Promise<Race> {
    const user: User = JSON.parse(race.user);
    race.user = await this.userService.findById(user.id);

    var locationCoords: LocationCoords[] = Array.from(JSON.parse(race.coords));
    race.coords = [];

    const savedRace = await this.raceRepository.save(race);

    await locationCoords.forEach(location => {
      location.race = savedRace;
      this.locationCoordsRepository.save(location);
    }); 

    savedRace.coords = await this.locationCoordsRepository.findByRaceId(savedRace.id)
    return savedRace;
  }

  async findById(id: number): Promise<Race> {
    this.logger.log(`Procurado pela corrida - id - ${id}`);

    const race = await this.raceRepository.findById(id);

    if (!race) {
      throw new NotFoundException(
        `A corrida com o ID ${id} nao foi encontrado.`,
      );
    }

    return race;
  }

  async findAllUserRaces(userId: number): Promise<Race[]> {
    this.logger.log(`Buscando todas as corridaspara o usario - id - ${userId}`);

    return await this.raceRepository.findAllUserRaces(userId);
  }

  async findUserMonthInfo(userId: number): Promise<UserInfo> {
    const currentDate = new Date();
    const firstDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);

    const races =  await this.raceRepository.findByDate(firstDayOfMonth, lastDayOfMonth, userId);
    const user = await this.userService.findById(userId);

    var kilometersCount: number = 0;
    var caloriesCount: number = 0;
    var tempoCount: number = 0;
    var metaAtingida: number = 0;
    var metaAtingidaPorcentagem: number = 0;

    this.logger.log(JSON.stringify(races));

    races.forEach(race => {
      kilometersCount += race.kilometers;
      caloriesCount += race.calories;
      tempoCount += race.time;
    });

    this.logger.log(tempoCount);

    const distinctDays = new Set(races.map(item => item.date.getDate()));
    metaAtingida = distinctDays.size;
    metaAtingidaPorcentagem = (metaAtingida / user.target)


    return new UserInfo(
      user.target,
      metaAtingida,
      metaAtingidaPorcentagem,
      caloriesCount,
      kilometersCount,
      tempoCount
    );
  }

  async findAll(): Promise<Race[]> {
    return await this.raceRepository.findAll();
  }

  async delete(id: number) {
    this.logger.log(`Deletando a corrida - id - ${id}`);

    const raceToDelete = await this.findById(id);

    if (!raceToDelete) {
      throw new NotFoundException(
        `Não foi possivel excluir a corrida com ID: ${id} pois ele não existe.`,
      );
    }

    var user = await this.userService.findById(1);
    raceToDelete.user = user;

    await this.raceRepository.update(raceToDelete);
  }
}
