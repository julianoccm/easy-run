import { Module } from "@nestjs/common";
import { UserController } from "./controllers/user.controller";
import { UserService } from "src/application/services/user.service";
import { RaceService } from "src/application/services/race.service";
import { RaceController } from "./controllers/race.controller";
import { AuthService } from "src/application/services/auth.service";
import { JwtModule } from "@nestjs/jwt";
import { AuthController } from "./controllers/auth.controller";

@Module({
  imports: [
    JwtModule.register({
      global: true,
      secret: "SECRET_KEY",
      signOptions: { expiresIn: '60000s' },
    }),
  ],
  providers: [UserService, RaceService, AuthService],
  controllers: [UserController, RaceController, AuthController],
})
export class HttpModule { }