import { Repository } from 'typeorm';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../../../application/entities/user.model';

@Injectable()
export default class UserRepository {
  
  constructor(@InjectRepository(User) private readonly userRepository: Repository<User>) {}

  async save(user: User): Promise<User> {
    user.id = null;
    return await this.userRepository.save(user);
  }

  async update(user: User): Promise<User> {
    return await this.userRepository.save(user);
  }

  async findById(id: number): Promise<User> {
    return await this.userRepository.findOne({
      where: {
        id: id,
      },
    });
  }

  async findByEmail(email: string): Promise<User> {
    return await this.userRepository.findOne({
      where: {
        email: email,
      },
    });
  }

  async findAll(): Promise<User[]> {
    return await this.userRepository.find();
  }

  async delete(id: number) {
    await this.userRepository.delete({
      id: id,
    });
  }
}
