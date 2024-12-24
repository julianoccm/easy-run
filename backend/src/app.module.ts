import { Module } from '@nestjs/common';
import { TypeOrmConfigModule } from './infra/database/typeorm-config.module';
import { HttpModule } from './infra/http/http.module';

@Module({
  imports: [TypeOrmConfigModule, HttpModule],
})
export class AppModule {}
