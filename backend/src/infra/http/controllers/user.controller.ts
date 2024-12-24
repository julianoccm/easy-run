import { Body, Controller, Delete, Get, Param, Post, Put } from "@nestjs/common";
import { User } from "src/application/entities/user.model";
import { UserService } from "src/application/services/user.service";

@Controller('user')
export class UserController {

  constructor(private readonly userService: UserService) {}

  @Get(':id')
  findById(@Param() params) {
    const user = this.userService.findById(params.id);
    return user;
  }

  @Get() 
  findAll() {
    return this.userService.findAll();
  }

  @Put('target/:userId/:newTarget') 
  updateTarget(@Param() params) {
    return this.userService.updateTarget(params.userId, params.newTarget);
  }

  @Post()
  save(@Body() user: User) {
    const savedUser = this.userService.save(user);
    return savedUser;
  }

  @Delete(':id')
  delete(@Param() params) {
    this.userService.delete(params.id);
  }
}