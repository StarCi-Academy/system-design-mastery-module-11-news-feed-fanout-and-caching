import {
    Module,
} from "@nestjs/common"
import {
    TypeOrmModule,
} from "@nestjs/typeorm"
import {
    FeedcacheController,
} from "./feedcache.controller"
import {
    FeedcacheService,
} from "./feedcache.service"
import {
    CachedPostEntity,
} from "../entities"

/**
 * Feature module — Postgres source + Redis ZSET feed cache (seed từ .sql/seed.sql).
 * (EN: Feature module — Postgres source + Redis ZSET feed cache (seed from .sql/seed.sql).)
 */
@Module({
    imports: [TypeOrmModule.forFeature([CachedPostEntity])],
    controllers: [FeedcacheController],
    providers: [FeedcacheService],
    exports: [FeedcacheService],
})
export class FeedcacheModule {}
