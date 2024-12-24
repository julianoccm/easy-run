import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { UserService } from './user.service';
import { JwtService } from '@nestjs/jwt';
import {JsonWebTokenError} from 'jsonwebtoken';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private userService: UserService, private jwtService: JwtService) {}

  async signIn(email: string, password: string) {
    const user = await this.userService.findByEmail(email);

    if(user?.password !== password) {
      throw new UnauthorizedException();
    }

    const payload = { sub: user.id, username: user.email };
    return {
      access_token: await this.jwtService.signAsync(payload),
      user: user
    };
  }

  async signInToken(token: string) {
    try {
      const userData = this.jwtService.verify(token);
      const user = await this.userService.findByEmail(userData.username);
    
      return user;
    } catch (exeception) {
      throw new UnauthorizedException();
    }
  }
}
