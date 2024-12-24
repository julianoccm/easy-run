import { Body, Controller, Delete, Get, Param, Post, Put } from "@nestjs/common";
import { Race } from "src/application/entities/race.model";
import { RaceService } from "src/application/services/race.service";

@Controller('race')
export class RaceController {

  constructor(private readonly raceService: RaceService) {}

  @Get(':id')
  findById(@Param() params) {
    const race = this.raceService.findById(params.id);
    return race;
  }

  @Get("user/:userId") 
  findAllByUser(@Param() params) {
    return this.raceService.findAllUserRaces(params.userId);
  }

  @Get("user/month/:userId")
  findMonthUserInfo(@Param() params) {
    return this.raceService.findUserMonthInfo(params.userId);
  }
  
  @Get() 
  findAll() {
    return this.raceService.findAll();
  }

  @Post()
  save(@Body() race: Race) {
    const savedRace = this.raceService.save(race);

    

    return savedRace;
  }

  @Delete(':id')
  delete(@Param() params) {
    this.raceService.delete(params.id);
  }
}