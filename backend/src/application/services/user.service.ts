import { User } from '../entities/user.model';
import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import UserRepository from 'src/infra/database/repositories/user.repository';

@Injectable()
export class UserService {
  private readonly logger = new Logger(UserService.name);

  constructor(private userRepository: UserRepository) {}

  async save(user: User): Promise<User> {
    const savedUser = await this.userRepository.save(user);
    return savedUser;
  }

  async findById(id: number): Promise<User> {
    this.logger.log(`Procurado pelo usuario - id - ${id}`);

    const user = await this.userRepository.findById(id);

    if (!user) {
      throw new NotFoundException(
        `O Usuario com o ID ${id} nao foi encontrado.`,
      );
    }

    return user;
  }

  async findByEmail(email: string): Promise<User> {
    this.logger.log(`Procurado pelo usuario - email - ${email}`);

    const user = await this.userRepository.findByEmail(email);

    if (!user) {
      throw new NotFoundException(
        `O Usuario com o email ${email} nao foi encontrado.`,
      );
    }

    return user;
  }

  async findAll(): Promise<User[]> {
    return await this.userRepository.findAll();
  }

  async updateTarget(userId: number, newTarget: number): Promise<User> {
    const user = await this.findById(userId);
    user.target = newTarget;

    return await this.userRepository.update(user);
  }

  async delete(id: number) {
    this.logger.log(`Deletando o usuario - id - ${id}`);

    const userToDelete = await this.findById(id);

    if (!userToDelete) {
      throw new NotFoundException(
        `Não foi possivel excluir o usuário com ID: ${id} pois ele não existe.`,
      );
    }

    userToDelete.email = "-";

    await this.userRepository.update(userToDelete);
  }
}
