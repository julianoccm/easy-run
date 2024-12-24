import { Body, Controller, Delete, Get, Param, Post, Put } from "@nestjs/common";
import { AuthService } from "src/application/services/auth.service";

@Controller('auth')
export class AuthController {

  constructor(private readonly authService: AuthService) {}

  @Post('login')
  signIn(@Body() signInDto: Record<string, any>) {
    return this.authService.signIn(signInDto.username, signInDto.password);
  }

  @Post('token')
  signInToken(@Body() signInTokenDto: Record<string, any>) {
    return this.authService.signInToken(signInTokenDto.token);
  }
}