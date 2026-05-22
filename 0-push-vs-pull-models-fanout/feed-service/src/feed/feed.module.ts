import {
    Module,
} from "@nestjs/common"
import {
    TypeOrmModule,
} from "@nestjs/typeorm"
import {
    FeedController,
} from "./feed.controller"
import {
    FeedService,
} from "./feed.service"
import {
    FollowEntity,
    PostEntity,
    PushedTimelineEntity,
} from "../entities"

/**
 * Feature module — fanout push vs pull (Postgres + seed từ .sql/seed.sql).
 * (EN: Feature module — fanout push vs pull (Postgres + seed from .sql/seed.sql).)
 */
@Module({
    imports: [
        TypeOrmModule.forFeature([FollowEntity, PostEntity, PushedTimelineEntity]),
    ],
    controllers: [FeedController],
    providers: [FeedService],
    exports: [FeedService],
})
export class FeedModule {}
