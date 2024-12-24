import { Repository } from 'typeorm';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../../../application/entities/user.model';
import { LocationCoords } from 'src/application/entities/location-coords.model';

@Injectable()
export default class LocationCoordsRepository {
  
  constructor(@InjectRepository(LocationCoords) private readonly locationCoords: Repository<LocationCoords>) {}

  async save(locationCoords: LocationCoords): Promise<LocationCoords> {
    return await this.locationCoords.save(locationCoords);
  }

  async findByRaceId(raceId: number):Promise<LocationCoords[]> {
    return await this.locationCoords.find({
      where: {
        race: {
          id: raceId
        }
      }
    })
  }
}
