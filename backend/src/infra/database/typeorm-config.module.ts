import { Global, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { LocationCoords } from 'src/application/entities/location-coords.model';
import { Race } from 'src/application/entities/race.model';
import { User } from 'src/application/entities/user.model';

import UserRepository from './repositories/user.repository';
import RaceRepository from './repositories/race-repository';
import LocationCoordsRepository from './repositories/location-coord-repository';

@Global()
@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DB_HOST || "localhost",
      port: parseInt(process.env.DB_PORT) || 3306,
      username: process.env.DB_USERNAME || "easyrun",
      password: process.env.DB_PASSWORD || "easyrun",
      database: process.env.DB_NAME || "easyrun",
      entities: ['dist/**/*.entity{.ts,.js}'],
      synchronize: true,
      autoLoadEntities: true,
    }),
    TypeOrmModule.forFeature([User, Race, LocationCoords]),
  ],
  providers: [UserRepository, RaceRepository, LocationCoordsRepository],
  exports: [UserRepository, RaceRepository, LocationCoordsRepository]
})
export class TypeOrmConfigModule {}
