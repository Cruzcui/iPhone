//
//  HKHeader.h
//  HisGuidline
//
//  Created by kimi on 13-10-15.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#ifndef HisGuidline_HKHeader_h
#define HisGuidline_HKHeader_h
//userInfo
#define URLForUpdateUserInfos @"http://121.199.26.12:8080/mguid/user/phone/update.do"
#define URLForgetUserInfos @"http://121.199.26.12:8080/mguid/user/phone/load.do"
#define URLForPostJianYi @"http://121.199.26.12:8080/mguid/feedback/phone/post.do"
#define URLForSystemOption @"http://121.199.26.12:8080/mguid/profile/phone/load.do"
#define URLForChangePassWord @"http://121.199.26.12:8080/mguid/user/phone/updatePass.do"

#define URLHomeAD @"http://121.199.26.12:8080/mguid/madvs/phone/select.do"
#define URLPortalAD @"http://www.56366.com:85/port/home/getAD.do"
#define URLCategoryListViewController @"http://121.199.26.12:8080/mguid/section/selectAll.do"
#define URLForZhiNanLieBiao @"http://121.199.26.12:8080/mguid/medguid/phone/select.do"
#define URLForMyPPTs @"http://121.199.26.12:8080/mguid/mppts/phone/select.do"
#define URLForDetailsPPTs @"http://121.199.26.12:8080/mguid/mppts/phone/getppts.do"
#define URLForYuanWenMuLu @"http://121.199.26.12:8080/mguid/medcontent/phone/selectIndex.do"
#define URLForMuLuDetail @"http://121.199.26.12:8080/mguid/medcontent/phone/loadContent.do"
#define URLForTest @"http://121.199.26.12:8080/mguid/medtesting/phone/select.do"
#define URLForShenXiPPT @"http://121.199.26.12:8080/mguid/mppts/phone/select.do"
#define URLForBiBao @"http://121.199.26.12:8080/mguid/mposter/phone/select.do"
#define URLForPingLunList @"http://121.199.26.12:8080/mguid/medrating/phone/getMedRating.do"
#define URLForScore @"http://121.199.26.12:8080/mguid/medrating/phone/getMedRatingCount.do"
#define URLForPost @"http://121.199.26.12:8080/mguid/medrating/phone/postMedRating.do"
#define URLForVideo @"http://121.199.26.12:8080/mguid/mvideos/phone/select.do"
#define URLForVotes @"http://121.199.26.12:8080/mguid/mvote/phone/select.do"
#define URLForPostAnswer @"http://121.199.26.12:8080/mguid/mvote/phone/postanswer.do"
#define URLForFaQiPost @"http://121.199.26.12:8080/mguid/mvote/phone/postvote.do"
//tools
#define URLForToolsGuid @"http://121.199.26.12:8080/mguid/meddict/phone/selectIndex.do"
#define URLForToolsContent @"http://121.199.26.12:8080/mguid/meddictcontent/phone/select.do"
#define URLForNews @"http://121.199.26.12:8080/mguid/news/phone/select.do"
#define URLForHelperList @"http://121.199.26.12:8080/mguid/help/phone/select.do"
#define URLForHelperContent @"http://121.199.26.12:8080/mguid/help/phone/selectReplay.do"
#define URLForHelpPost @"http://121.199.26.12:8080/mguid/help/phone/postReplay.do"
#define URLForPostHelp @"http://121.199.26.12:8080/mguid/help/phone/post.do"
//expert
#define URLForGetExpertContent @"http://121.199.26.12:8080/mguid/meddis/phone/loadAuthor.do"
#define URLForGetQuestionAndReplayList @"http://121.199.26.12:8080/mguid/meddis/phone/select.do"
#define URLForPostExpert @"http://121.199.26.12:8080/mguid/meddis/phone/post.do"
//收藏URL
#define  URLForSelected @"http://121.199.26.12:8080/mguid/myfav/phone/addFav.do"
#define  URLForUnSelected @"http://121.199.26.12:8080/mguid/myfav/phone/delFav.do"
#define  URLForMySelectedBiBao @"http://121.199.26.12:8080/mguid/mposter/phone/selectFav.do"
#define URLForMySelectedPPT @"http://121.199.26.12:8080/mguid/mppts/phone/selectFav.do"
#define URLForMySelectedVideo @"http://121.199.26.12:8080/mguid/mvideos/phone/selectFav.do"
#define URLForMySelectedTools @"http://121.199.26.12:8080/mguid/meddictcontent/phone/selectFav.do"
// Json Header Define
#define JsonHead_dataList       @"dataList"
#define JsonHead_success         @"success"

//会议URL
//121.199.26.12
//192.168.1.22
#define URL_huiyi @"http://121.199.26.12:8080/mguid/meeting/phone/select.do"
#define URL_huiyiDetail @"http://121.199.26.12:8080/mguid/meeting/phone/load.do"
#endif

//系统消息
#define URLSysmessaee @"http://121.199.26.12:8080/mguid/messages/phone/select.do"
#define URLSysmessageDetail @"http://121.199.26.12:8080/mguid/messages/phone/message/%@.html"

#define JsonHead_status         @"status"
#define JsonHead_resultMsg      @"resultMsg"
#define JsonHead_resultMessage   @"resultMessage"
#define JsonHead_searchTime      @"searchTime"
#define JsonHead_data           @"data"
