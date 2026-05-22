import {
    Module,
} from "@nestjs/common"
import {
    TypeOrmModule,
} from "@nestjs/typeorm"
import {
    HybridfeedController,
} from "./hybridfeed.controller"
import {
    HybridfeedService,
} from "./hybridfeed.service"
import {
    AuthorEntity,
    HybridPostEntity,
} from "../entities"

/**
 * Feature module — hybrid fanout + Postgres + Redis key salting (seed từ .sql/seed.sql).
 * (EN: Feature module — hybrid fanout + Postgres + Redis key salting (seed from .sql/seed.sql).)
 */
@Module({
    imports: [TypeOrmModule.forFeature([AuthorEntity, HybridPostEntity])],
    controllers: [HybridfeedController],
    providers: [HybridfeedService],
    exports: [HybridfeedService],
})
export class HybridfeedModule {}
