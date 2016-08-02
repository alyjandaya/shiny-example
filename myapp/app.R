library(shiny)
library(shinyjs)

jsResetCode <- "shinyjs.reset = function() {history.go(0)}"
dfR <- CacheOrQueryRedshift(" with ruf as (
                            
                            
                            with nps as (
                            
                            select date('1970-01-01'::timestamp + interval '1 second' * unix_time/1000) as rating_date, product, username, rating, comment, role, CAST(parent_sen as INT) from nps.raw_survey_submits 
                            where instance not like '%jira-dev.com'
                            and instance not like 'sdog.jira.com'
                            and instance not in ('fardinsarker.atlassian.net', 'shipit.atlassian.net')
                            )
                            
                            select distinct comment, concat(username, parent_sen) as unique_user_id, parent_sen, product, username, rating, rating_date, role,
                            case when ((comment ilike '%buggy%'
                            
                            --RELIABILITY--
                            or comment ilike '%broken%'
                            or comment ilike '%stuck%'
                            or comment ilike '%doesn work%'
                            or comment ilike '%error%'
                            or comment ilike '%cannot run%'
                            or comment ilike '%exception%'
                            or comment ilike '%stack trace%'
                            or comment ilike '%stacktrace%'
                            or comment ilike '%index issue%'
                            or comment ilike '%currupt%'
                            or comment ilike '%not updating%'
                            or comment ilike '%unable to index%'
                            or comment ilike '%bug ridden%'
                            or comment ilike '%unstable%'
                            or comment ilike '%lot of bugs%'
                            or comment ilike '%buginess%'
                            or comment ilike '%resolve bugs%'
                            or comment ilike '%bugs in jira%'
                            or (comment ilike '%recent update%' and comment ilike '%issue%')
                            and (comment not ilike '%bug track%'))
                            or comment ilike '%maintenance%'
                            or comment ilike '%downtime window%'
                            or comment ilike '%migration schedule%'
                            or comment ilike '%downtime%'
                            or comment ilike '%down time%'
                            or comment ilike '%is down%'
                            or comment ilike '%outage%'
                            or comment ilike '%crash%'
                            or comment ilike '%dead%'
                            or comment ilike '%unreachable%'
                            or comment ilike '%unavailable%'
                            or comment ilike '%page unavailable%'
                            or comment ilike '%inaccessible%'
                            or comment ilike '%cannot connect%'
                            or comment ilike '%can_t connect%'
                            or comment ilike '%cannot access%'
                            or comment ilike '%can_t access%'
                            or comment ilike '%can_t reach%'
                            or comment ilike '%cannot reach%'
                            or comment ilike '%not available%'
                            or comment ilike '%not loading%'
                            or comment ilike '%not responding%'
                            or comment ilike '%not reachable%'
                            or comment ilike '%not accessible%'
                            or comment ilike '%not operational%'
                            or comment ilike '%not working%'
                            or comment ilike '%does not work%'
                            or comment ilike '%doesn_t work%'
                            or comment ilike '%unable to access%'
                            or comment ilike '%not able to access%'
                            or comment ilike '%doesn_t load%'
                            or comment ilike '%wont load%'
                            or comment ilike '%won_t load%'
                            or comment ilike '%timing out%'
                            or comment ilike  '%speed%'
                            or comment ilike  '%slow%'
                            or comment ilike  '%sloow%'
                            or comment ilike  '%sloooow%'
                            or comment ilike  '%fast%'
                            or comment ilike  '%performance%'
                            or comment ilike  '%seconds%'
                            or comment ilike  '%loading content%'
                            or comment ilike  '%content loading%'
                            or comment ilike  '%loading time%'
                            or comment ilike  '%loading page%'
                            or comment ilike  '%loading takes%'
                            or ((comment ilike '%load%') and (comment ilike '%long time%' or comment ilike '%too long%'))
                            or comment ilike  '%page load%'
                            or comment ilike  '%sluggish%'
                            or comment ilike  '%latency%'
                            or comment ilike  '%run quicker%' 
                            or comment ilike '%was quicker%'
                            or ((comment ilike '%ondemand%' or comment ilike '%on demand%') and (comment ilike '%quicker%'))
                            or comment ilike '%response time%'
                            or comment ilike  '%unresponsive%'
                            --From Confluence--
                            or comment ilike  '%loading%'
                            or comment ilike  '%lag%'
                            or comment ilike  '%run quicker%'
                            or comment ilike  '%was quicker%'
                            or comment ilike  '%response time%'
                            or comment ilike  '%exception%'
                            or comment ilike  '%ondemand%'
                            or comment ilike  '%on demand%'
                            or comment ilike  '%quirk%'
                            or comment ilike  '%error%'
                            or comment ilike  '%bug%'
                            or comment ilike  '%glitch%'
                            or comment ilike  '%problems with%'
                            or comment ilike  '%broken%'
                            or comment ilike  '%not updating%'
                            or comment ilike  '%recent update%'
                            or comment ilike  '%maintenance%'
                            or comment ilike  '%not working%'
                            or comment ilike  '%does not work%'
                            or comment ilike  '%doesn work%'
                            or comment ilike  '%doesn_t work%'
                            or comment ilike  '%corrupt%'
                            or comment ilike  '%index issue%'
                            or comment ilike  '%reliability%'
                            or comment ilike  '%reliable%'
                            or comment ilike  '%stability%'
                            or comment ilike  '%stable%'
                            or comment ilike  '%quality%'
                            or comment ilike  '%reload%'
                            or comment ilike  '%restart%'
                            or comment ilike  '%quicker%'
                            or comment ilike  '%not responding%'
                            or comment ilike  '%unreachable%'
                            or comment ilike  '%not reachable%'
                            or comment ilike  '%inaccessible%'
                            or comment ilike  '%not accessible%'
                            or comment ilike  '%goes down%'
                            or comment ilike  '%times out%'
                            or comment ilike  '%timing out%'
                            or comment ilike  '%outage%'
                            or comment ilike  '%downtime%'
                            or comment ilike  '%down time%'
                            or comment ilike  '%uptime%'
                            or comment ilike  '%crash%'
                            or comment ilike  '%gone down%'
                            or comment ilike  '%hangs%'
                            or comment ilike  '%freez%'
                            or comment ilike  '%stuck%'
                            or comment ilike  '%is down%'
                            or comment ilike  '%unable to index%'
                            or comment ilike  '%unavailable%'
                            or comment ilike  '%not available%'
                            or comment ilike  '%cannot access%'
                            or comment ilike  '%can_t access%'
                            or comment ilike  '%unable to access%'
                            or comment ilike  '%not able to access%'
                            or comment ilike  '%can_t reach%'
                            or comment ilike  '%cannot reach%'
                            or comment ilike  '%can_t connect%'
                            or comment ilike  '%cannot connect%'
                            --From Hipchat--
                            or comment ilike  '%connect%'
                            or comment ilike  '%flaky%'
                            or comment ilike  '%too long%'
                            or comment ilike  '%too much time%'
                            or comment ilike  '%going down%'
                            or comment ilike  '%hang%'
                            --From BitBucket--
                            or comment ilike  '%down%'
                            or comment ilike  '%unstab%'
                            or comment ilike  '%unrelia%'
                            or comment ilike  '%not_relia%'
                            or comment ilike  '%forever%'
                            or comment ilike  '%trust%') then 1 else 0 end as Reliability 
                            from nps)
                            
                            select comment as Question
                            from ruf
                            where comment is not null and char_length(comment)>20
                            and comment not ilike '%;%'
                            and comment not in (select comment from ccarter.nlp_trainer where classification ilike '%r%')
                            limit 50;")

dfU <- CacheOrQueryRedshift("
with ruf as (
                            
                            
                            with nps as (
                            
                            select date('1970-01-01'::timestamp + interval '1 second' * unix_time/1000) as rating_date, product, username, rating, comment, role, CAST(parent_sen as INT) from nps.raw_survey_submits 
                            where instance not like '%jira-dev.com'
                            and instance not like 'sdog.jira.com'
                            and instance not in ('fardinsarker.atlassian.net', 'shipit.atlassian.net')
                            )
                            
                            select distinct comment, concat(username, parent_sen) as unique_user_id, parent_sen, product, username, rating, rating_date, role,
                            case when ((comment ilike'%side nav%'
                            --USABILITY--
                            or comment ilike'%side bar%'
                            or comment ilike '%sidebar%'   
                            or comment ilike'%quick filter%'   
                            or comment ilike'%top nav%'
                            or comment ilike'%navigat%'
                            or comment ilike '%can%t find%'
                            or comment ilike '%cannot find%'
                            or comment ilike '%where is%'
                            or comment ilike'%\ search%'
                            or comment ilike '%\ jql %'
                            or (comment ilike '%better%' and comment ilike '%search%')
                            or comment ilike '%too clicky%'
                            or comment ilike '%Too much clicking%'
                            or comment ilike '%too many clicks%'
                            or comment ilike'%admin%'
                            or comment ilike'%scheme%'
                            or comment ilike'%setup%'
                            or comment ilike'%permission%'
                            or comment ilike'%config%'
                            or comment ilike'%fix version%'
                            or comment ilike'%edit version%'
                            or comment ilike'%component%'
                            or comment ilike '%layout%'
                            or comment ilike '%ugly%'
                            or comment ilike '%ui %'
                            or comment ilike '%\ ui%'
                            or comment ilike 'ui'
                            or comment ilike '%\ gui %'
                            or comment ilike '%cluttered%'
                            or comment ilike '%interface%'
                            or comment ilike '%boring%'
                            or comment ilike '%outdated%'
                            or comment ilike '%modern%'
                            or comment ilike '%as a designer%'
                            or comment ilike '%clunky%'
                            or comment ilike '%simplicity%'
                            or comment ilike '%user friendly%'
                            or comment ilike '%un-friendly%'
                            or comment ilike '%complex%'
                            or comment ilike '%complicated%'
                            or comment ilike '%confuse%'
                            or comment ilike '%confusion%'
                            or comment ilike '%cumbersome%'
                            or comment ilike '%how to%'
                            or comment ilike '%difficult%'
                            or comment ilike '%design%'
                            or comment ilike '%need help%'
                            or comment ilike '%too hard%'
                            or comment ilike '%simplify%'
                            or comment ilike '%simpler%'
                            or comment ilike '%bloat%'
                            or comment ilike '%intuitive%'
                            or comment ilike '%intuative%'
                            or comment ilike '%navigate%'
                            or comment ilike '%easy%'
                            or comment ilike '%ease of use%'
                            or comment ilike '%works great%'
                            or comment ilike '%ux %'
                            or comment ilike '%\ ux%'
                            or comment ilike 'ux'
                            or comment ilike '%user experience%'
                            or comment ilike '%confusing%'
                            or comment ilike '%convoluted%'
                            or comment ilike '%too many%'
                            or comment ilike '%not%friendly%'
                            or comment ilike '%more%friendly%'
                            or comment ilike '%many clicks%'
                            or comment ilike '%documentation%'
                            or comment ilike '%resources%'
                            or comment ilike '%educate%'
                            or comment ilike '%instruction%' 
                            or comment ilike '%practical%' 
                            or comment ilike '%filter%' 
                            or comment ilike '%difficult to manage%' 
                            or comment ilike '%integrate%'
                            or comment ilike '%simpler%' 
                            or comment ilike '%obvious%' 
                            or comment ilike '%make eas%' 
                            or comment ilike '%training%' 
                            or comment ilike '%easier%' 
                            or comment ilike '%pain%'  
                            or comment ilike '%usability%' 
                            or comment ilike '%understand%use%'
                            or comment ilike '%time consuming%'
                            --From Confluence2--
                            or comment ilike  '%edit%'
                            or comment ilike  '%editor%'
                            or comment ilike  '%format%'
                            or comment ilike  '%markup%'
                            or comment ilike  '%markdown%'
                            or comment ilike  '%source%code%'
                            or comment ilike  '%source%page%'
                            or comment ilike  '%edit%source%'
                            or comment ilike  '%html%'
                            or comment ilike  '%wysiwyg%'
                            or comment ilike  '%table%'
                            or comment ilike  '%column%'
                            or comment ilike  '%width%'
                            or comment ilike  '%resize%'
                            or comment ilike  '%format%issue%'
                            or comment ilike  '%issue%format%'
                            or comment ilike  '%difficult%format%'
                            or comment ilike  '%format%difficult%'
                            or comment ilike  '%option%format%'
                            or comment ilike  '%format%option%'
                            or comment ilike  '%change%format%'
                            or comment ilike  '%editor%eas%use%'
                            or comment ilike  '%editor%annoy%'
                            or comment ilike  '%difficult%editor%'
                            or comment ilike  '%editor%difficult%'
                            or comment ilike  '%editor%interface%'
                            or comment ilike  '%editing%option%'
                            or comment ilike  '%editor%clunky%'
                            or comment ilike  '%editor%polish%'
                            or comment ilike  '%polish%editor%'
                            or comment ilike  '%improve%editor%'
                            or comment ilike  '%confusing%edit%'
                            or comment ilike  '%easy%edit%'
                            or comment ilike  '%highlight%text%'
                            or comment ilike  '%delete%text%'
                            or comment ilike  '%select%text%'
                            or comment ilike  '%font%size%'
                            or comment ilike  '%font%style%'
                            or comment ilike  '%font%type%'
                            or comment ilike  '%font%'
                            or comment ilike  '%text%'
                            or comment ilike  '%paragraph%'
                            or comment ilike  '%title%'
                            or comment ilike  '%link%'
                            or comment ilike  '%bullet%'
                            or comment ilike  '%list%'
                            or comment ilike  '%macro%'
                            or comment ilike  '%image%'
                            or comment ilike  '%chart%'
                            or comment ilike  '%create%page%'
                            or comment ilike  '%create%button%'
                            or comment ilike  '%save%page%'
                            or comment ilike  '%create%'
                            or comment ilike  '%page%template%'
                            or comment ilike  '%page%layout%'
                            or comment ilike  '%ppt%'
                            or comment ilike  '%powerpoint%'
                            or comment ilike  '%attachment%'
                            or comment ilike  '%file%'
                            or comment ilike  '%import%'
                            or comment ilike  '%export%'
                            or comment ilike  '%pdf%'
                            or comment ilike  '%copy%word%'
                            or comment ilike  '%paste%word%'
                            or comment ilike  '%to find%'
                            or comment ilike  '%can find%'
                            or comment ilike  '%cant find%'
                            or comment ilike  '%can_t find%'
                            or comment ilike  '%keep up%'
                            or comment ilike  '%hidden%'
                            or comment ilike  '%important info%'
                            or comment ilike  '%important pag%'
                            or comment ilike  '%important stuff%'
                            or comment ilike  '%bookmark%'
                            or comment ilike  '%favorite%'
                            or comment ilike  '%discover%'
                            or comment ilike  '%locat%'
                            or comment ilike  '%navigat%'
                            or comment ilike  '%side nav%'
                            or comment ilike  '%side bar%'
                            or comment ilike  '%sidebar%'
                            or comment ilike  '%quick filter%'
                            or comment ilike  '%top nav%'
                            or comment ilike  '%filter%'
                            or comment ilike  '%sub page%'
                            or comment ilike  '%folder%'
                            or comment ilike  '%sort%'
                            or comment ilike  '%tree%'
                            or comment ilike  '%left%'
                            or comment ilike  '%pane%'
                            or comment ilike  '%search%'
                            or comment ilike  '%hard to find%feature%'
                            or comment ilike  '%many%feature%'
                            or comment ilike  '%many%functionality%'
                            or comment ilike  '%edit %button%'
                            or comment ilike  '%1990%'
                            or comment ilike  '%1999%'
                            or comment ilike  '%2002%'
                            or comment ilike  '%ui%'
                            or comment ilike  '%dated%'
                            or comment ilike  '%ux%'
                            or comment ilike  '%xd%'
                            or comment ilike  '%gui%'
                            or comment ilike  '%90_s%'
                            or comment ilike  '%90s%'
                            or comment ilike  '%beautiful%'
                            or comment ilike  '%boring%'
                            or comment ilike  '%color%'
                            or comment ilike  '%design%'
                            or comment ilike  '%dull%'
                            or comment ilike  '%feels old%'
                            or comment ilike  '%look and feel%'
                            or comment ilike  '%looks terrible%'
                            or comment ilike  '%outdated%'
                            or comment ilike  '%polish%'
                            or comment ilike  '%prettier%'
                            or comment ilike  '%slick%'
                            or comment ilike  '%style%'
                            or comment ilike  '%too small%'
                            or comment ilike  '%ugly%'
                            or comment ilike  '%user experience%'
                            or comment ilike  '%visual%'
                            or comment ilike  '%old%'
                            or comment ilike  '%layout%'
                            or comment ilike  '%modern%'
                            or comment ilike  '%clunky%'
                            or comment ilike  '%complex%'
                            or comment ilike  '%interface%'
                            or comment ilike  '%too much%'
                            or comment ilike  '%too many%'
                            or comment ilike  '%clutter%'
                            or comment ilike  '%bloat%'
                            or comment ilike  '%readability%'
                            or comment ilike  '%hard to see%'
                            or comment ilike  '%clear%'
                            or comment ilike  '%buried%'
                            or comment ilike  '%too clicky%'
                            or comment ilike  '%convoluted%'
                            or comment ilike  '%many clicks%'
                            or comment ilike  '%awareness%'
                            or comment ilike  '%potential%'
                            or comment ilike  '%intuitive%'
                            or comment ilike  '%to learn%'
                            or comment ilike  '%to understand%'
                            or comment ilike  '%difficult to learn%'
                            or comment ilike  '%figure%'
                            or comment ilike  '%get started%'
                            or comment ilike  '%guide%'
                            or comment ilike  '%need_help%'
                            or comment ilike  '%more obvious%'
                            or comment ilike  '%not clear%'
                            or comment ilike  '%scheme%'
                            or comment ilike  '%config%'
                            or comment ilike  '%confuse%'
                            or comment ilike  '%confusion%'
                            or comment ilike  '%obvious%'
                            or comment ilike  '%easy%'
                            or comment ilike  '%convenient%'
                            or comment ilike  '%why%painful%'
                            or comment ilike  '%%how can i%'
                            or comment ilike  '%how do i%'
                            or comment ilike  '%no way to%'
                            or comment ilike  '%awkward%'
                            or comment ilike  '%can_t even%'
                            or comment ilike  '%can_t create%'
                            or comment ilike  '%can_t figure%'
                            or comment ilike  '%can_t order%'
                            or comment ilike  '%can_t see%'
                            or comment ilike  '%can_t seem%'
                            or comment ilike  '%cannot find%'
                            or comment ilike  '%complicated%'
                            or comment ilike  '%easier%'
                            or comment ilike  '%to use%'
                            or comment ilike  '%confusing%'
                            or comment ilike  '%could not find%'
                            or comment ilike  '%cumbersome%'
                            or comment ilike  '%easiest%'
                            or comment ilike  '%difficult to%'
                            or comment ilike  '%easy to miss%'
                            or comment ilike  '%hard time%'
                            or comment ilike  '%hard to%'
                            or comment ilike  '%way to change%'
                            or comment ilike  '%friendly%'
                            or comment ilike  '%should be easy%'
                            or comment ilike  '%simpler way%'
                            or comment ilike  '%usability%'
                            or comment ilike  '%useable%'
                            or comment ilike  '%works%'
                            or comment ilike  '%where is%'
                            or comment ilike  '%simplicity%'
                            or comment ilike  '%simplify%'
                            or comment ilike  '%simpler%'
                            or comment ilike  '%how to%'
                            or comment ilike  '%difficult%'
                            or comment ilike  '%too hard%'
                            or comment ilike  '%ease of use%'
                            or comment ilike  '%not%friendly%'
                            or comment ilike  '%more%friendly%'
                            or comment ilike  '%documentation%'
                            or comment ilike  '%educate%'
                            or comment ilike  '%practical%'
                            or comment ilike  '%difficult to manage%'
                            or comment ilike  '%make eas%'
                            or comment ilike  '%pain%'
                            or comment ilike  '%understand%use%'
                            or comment ilike  '%time consuming%'
                            or comment ilike  '%permission%'
                            or comment ilike  '%administration%'
                            or comment ilike  '%limit%user%'
                            or comment ilike  '%limit%access%'
                            or comment ilike  '%read%only%'
                            or comment ilike  '%practice%'
                            or comment ilike  '%guides%'
                            or comment ilike  '%documentation%incorrect%'
                            or comment ilike  '%training%'
                            or comment ilike  '%get help%'
                            or comment ilike  '%online help%'
                            or comment ilike  '%tutorial%'
                            or comment ilike  '%contact%support%'
                            or comment ilike  '%instruction%'
                            or comment ilike  '%add_on%'
                            or comment ilike  '%addon%'
                            or comment ilike  '%plug_in%'
                            or comment ilike  '%plugin%'
                            or comment ilike  '%integration%'
                            or comment ilike  '%integrate%'
                            or comment ilike  '%notif%'
                            or comment ilike  '%email%'
                            or comment ilike  '%e-mail%'
                            or comment ilike  '%nois%'
                            or comment ilike  '%share a page%'
                            or comment ilike  '%watch a page%'
                            or comment ilike  '%comment%'
                            or comment ilike  '%inline%'
                            or comment ilike  '%account%'
                            or comment ilike  '%admin%'
                            or comment ilike  '%rights%'
                            or comment ilike  '%billing%'
                            or comment ilike  '%manag%users%'
                            or comment ilike  '%add%users%'
                            --From HipChat2--
                            or comment ilike  '%correct%'
                            or comment ilike  '%delete%'
                            or comment ilike  '%last message%'
                            or comment ilike  '%able to%'
                            or comment ilike  '%change%'
                            or comment ilike  '%deep%'
                            or comment ilike  '%get_started%'
                            or comment ilike  '%hard%'
                            or comment ilike  '%not able%'
                            or comment ilike  '%odd%'
                            or comment ilike  '%see%'
                            or comment ilike  '%seem%'
                            or comment ilike  '%simple%'
                            or comment ilike  '%to change%'
                            or comment ilike  '%user friendly%'
                            or comment ilike  '%way to%'
                            or comment ilike  '%work%'
                            or comment ilike  '%prett%'
                            or comment ilike  '%custom%'
                            or comment ilike  '%2000%'
                            or comment ilike  '%looks%'
                            or comment ilike  '%small%'
                            or comment ilike  '%large%'
                            or comment ilike  '%blue%'
                            or comment ilike  '%size%'
                            or comment ilike  '%as Slack%'
                            or comment ilike  '%organize%'
                            or comment ilike  '%order%'
                            or comment ilike  '%scroll%'
                            or comment ilike  '%group%people%'
                            or comment ilike  '%group%room%'
                            or comment ilike  '%find%'
                            or comment ilike  '%keep_up%'
                            or comment ilike  '%important_info%'
                            or comment ilike  '%important_pag%'
                            or comment ilike  '%important_stuff%'
                            or comment ilike  '%save_page%'
                            or comment ilike  '%temporary%'
                            or comment ilike  '%ad-hoc%'
                            or comment ilike  '%per_room%'
                            or comment ilike  '%room_level%'
                            or comment ilike  '%notification%'
                            or comment ilike  '%offline%'
                            or comment ilike  '%miss%'
                            or comment ilike  '%mobile%'
                            or comment ilike  '%iphone%'
                            or comment ilike  '%ios%'
                            or comment ilike  '%android%'
                            or comment ilike  '%push notif%'
                            or comment ilike  '%miss%offline%'
                            or comment ilike  '%alert%message%'
                            or comment ilike  '%miss%message%'
                            or comment ilike  '%message%miss%'
                            or comment ilike  '%chat%missed%'
                            or comment ilike  '%realize%message%'
                            or comment ilike  '%offline%message%'
                            or comment ilike  '%message%offline%'
                            or comment ilike  '%offline%notif%'
                            or comment ilike  '%unread%'
                            or comment ilike  '%room%notif%'
                            or comment ilike  '%notification%annoying%'
                            or comment ilike  '%silent%notif%%'
                            or comment ilike  '%quiet%notif%%'
                            or comment ilike  '%turn%off%notif%'
                            or comment ilike  '%notif%turn%off%'
                            or comment ilike  '%noisy%'
                            or comment ilike  '%many%disruption%'
                            or comment ilike  '%sync%'
                            --From BitBucket2--
                            or comment ilike  '%clean%'
                            or comment ilike  '%UI%'
                            or comment ilike  '%streamline%'
                            or comment ilike  '%UX%'
                            or comment ilike  '%usab%'
                            or comment ilike  '%feel%'
                            or comment ilike  '%complicat%'
                            or comment ilike  '%simpl%'
                            or comment ilike  '%confus%'
                            or comment ilike  '%experience%'
                            or comment ilike  '%guid%'
                            or comment ilike  '%video%'
                            or comment ilike  '%onboard%'
                            or comment ilike  '%learning curve%')) then 1 else 0 end as Usability
                            
                            
                            from nps)
                            
                            select comment
                            from ruf
                            where comment is not null and char_length(comment)>20
                            and comment not ilike '%;%'
                            and comment not in (select comment from ccarter.nlp_trainer where classification ilike '%u%')
                            limit 50;")

dfF <- CacheOrQueryRedshift("with ruf as (

                            
                            with nps as (
                            
                            select date('1970-01-01'::timestamp + interval '1 second' * unix_time/1000) as rating_date, product, username, rating, comment, role, CAST(parent_sen as INT) from nps.raw_survey_submits 
                            where instance not like '%jira-dev.com'
                            and instance not like 'sdog.jira.com'
                            and instance not in ('fardinsarker.atlassian.net', 'shipit.atlassian.net')
                            )
                            
                            select distinct comment, concat(username, parent_sen) as unique_user_id, parent_sen, product, username, rating, rating_date, role,
                            case when ((comment ilike '%mobile%'
                            --FUNCTIONALITY--
                            or comment ilike '%ipad%'
                            or comment ilike '%tablet%'
                            or comment ilike '%iphone%'
                            or comment ilike '%ios%'
                            or comment ilike '%price%'
                            or comment ilike '%affordable%'
                            or comment ilike '%expensive%'
                            or comment ilike '%pricing%'
                            or comment ilike '%customis%'
                            or comment ilike '%customiz%'
                            or comment ilike '%suggest%feature%'
                            or comment ilike '%nice to%'
                            or comment ilike '%like to%'
                            or comment ilike '%i wish%'
                            or comment ilike '%any chance%'
                            or (comment ilike '%reporting%' and comment ilike '%need%')
                            or comment ilike '%more function%'
                            or comment ilike '%like to see%features%'
                            or comment ilike '%customize%'
                            or comment ilike '%integration%'
                            or comment ilike '%limitation%'
                            or comment ilike '%really need%'
                            or comment ilike '%need ability%'
                            or comment ilike '%feature%be%useful%'
                            or comment ilike '%translation%'
                            or comment ilike '%function%'
                            or comment ilike '%feature%'
                            or comment ilike '%option%'
                            or comment ilike '%include%'
                            or comment ilike '%be great%'
                            or comment ilike '%have abil%'
                            or comment ilike '%like abil%'
                            or comment ilike '%be able%'
                            or comment ilike '%provide%'
                            or comment ilike '%want ability%'
                            or comment ilike '%need way to%'
                            or comment ilike '%should have a way%'
                            or comment ilike '%would desire%'
                            or comment ilike '%would want%'
                            or comment ilike '%desire to see%'
                            or comment ilike '%would be benefit%'
                            or comment ilike '%doesn_t have%'
                            or comment ilike '%missing%'
                            --From Confluence3--
                            or comment ilike  '%google%doc%'
                            or comment ilike  '%collaborative%edit%'
                            or comment ilike  '%real%time%'
                            or comment ilike  '%concurrent%'
                            or comment ilike  '%copy_page%'
                            or comment ilike  '%page_hierarchy%'
                            or comment ilike  '%section%'
                            or comment ilike  '%paragraph%edit%'
                            or comment ilike  '%edit%restriction%'
                            or comment ilike  '%page%restriction%'
                            or comment ilike  '%inherit%'
                            or comment ilike  '%copy%space%'
                            or comment ilike  '%duplicate%space%'
                            or comment ilike  '%reimport%'
                            or comment ilike  '%numbered%head%'
                            or comment ilike  '%format%head%'
                            or comment ilike  '%child%page%'
                            or comment ilike  '%watch%page%'
                            or comment ilike  '%blog%template%'
                            or comment ilike  '%group%mention%'
                            or comment ilike  '%grop%watch%'
                            or comment ilike  '%space%key%'
                            or comment ilike  '%lync%'
                            or comment ilike  '%edit%attachments%'
                            or comment ilike  '%chrome%'
                            or comment ilike  '%gravatar%'
                            or comment ilike  '%google%'
                            or comment ilike  '%directory%'
                            or comment ilike  '%restrict_access%'
                            or comment ilike  '%user%profile%'
                            or comment ilike  '%user%name%'
                            or comment ilike  '%username%'
                            or comment ilike  '%space_template%'
                            or comment ilike  '%JIRA%search%'
                            or comment ilike  '%search%JIRA%'
                            or comment ilike  '%nest%space%'
                            or comment ilike  '%nested%space%'
                            or comment ilike  '%add%page%permissions%'
                            or comment ilike  '%admin%page%'
                            or comment ilike  '%grant%'
                            or comment ilike  '%LDAP%'
                            or comment ilike  '%page_via_email%'
                            or comment ilike  '%trash%'
                            or comment ilike  '%id_like%'
                            or comment ilike  '%would_like%'
                            or comment ilike  '%suggest%feature%'
                            or comment ilike  '%nice to%'
                            or comment ilike  '%like to%'
                            or comment ilike  '%i wish%'
                            or comment ilike  '%any chance%'
                            or comment ilike  '%more function%'
                            or comment ilike  '%like to see%'
                            or comment ilike  '%really need%'
                            or comment ilike  '%function%'
                            or comment ilike  '%feature%'
                            or comment ilike  '%option%'
                            or comment ilike  '%include%'
                            or comment ilike  '%be great%'
                            or comment ilike  '%have abil%'
                            or comment ilike  '%like abil%'
                            or comment ilike  '%be able%'
                            or comment ilike  '%provide%'
                            or comment ilike  '%need ability%'
                            or comment ilike  '%want ability%'
                            or comment ilike  '%need way to%'
                            or comment ilike  '%should have a way to%'
                            or comment ilike  '%would desire%'
                            or comment ilike  '%would want%'
                            or comment ilike  '%desire to see%'
                            or comment ilike  '%would be benefi%'
                            or comment ilike  '%doesn_t have%'
                            or comment ilike  '%missing%'
                            or comment ilike  '%customis%'
                            or comment ilike  '%customiz%'
                            or comment ilike  '%customize%'
                            or comment ilike  '%limitations%'
                            or comment ilike  '%translation%'
                            or comment ilike  '%price%'
                            or comment ilike  '%pricing%'
                            or comment ilike  '%affordable%'
                            or comment ilike  '%expensive%'
                            or comment ilike  '%phone%'
                            or comment ilike  '%ipad%'
                            or comment ilike  '%tablet%'
                            --From HipChat3--
                            or comment ilike  '%bookmark%message%'
                            or comment ilike  '%star%message%'
                            or comment ilike  '%favorite%message%'
                            or comment ilike  '%important%message%'
                            or comment ilike  '%multiple%'
                            or comment ilike  '%accounts%'
                            or comment ilike  '%conference%'
                            or comment ilike  '%group%video%'
                            or comment ilike  '%group%call%'
                            or comment ilike  '%multi%call%'
                            or comment ilike  '%multi%video%'
                            or comment ilike  '%hangouts%video%'
                            or comment ilike  '%skype%video%'
                            or comment ilike  '%windows phone%'
                            or comment ilike  '%SSO%'
                            or comment ilike  '%single_sign%'
                            or comment ilike  '%Crowd%'
                            or comment ilike  '%Active_directory%'
                            or comment ilike  '%code%'
                            or comment ilike  '%announcement%'
                            or comment ilike  '%poll%'
                            or comment ilike  '%proxy%'
                            or comment ilike  '%jenkins%'
                            or comment ilike  '%IFTTT%'
                            or comment ilike  '%heroku%'
                            or comment ilike  '%AWS%'
                            or comment ilike  '%compact_mode%'
                            or comment ilike  '%calendar%'
                            or comment ilike  '%outlook%'
                            or comment ilike  '%avatar%'
                            or comment ilike  '%two_factor%'
                            or comment ilike  '%authentication%'
                            or comment ilike  '%ban%guest%'
                            or comment ilike  '%built_in%'
                            --From BitBucket3--
                            or comment ilike  '%declin%'
                            or comment ilike  '%reopen%'
                            or comment ilike  '%4954%'
                            or comment ilike  '%squash%'
                            or comment ilike  '%revert%'
                            or comment ilike  '%8995%'
                            or comment ilike  '%IDE%'
                            or comment ilike  '%visual studio%'
                            or comment ilike  '%android studio%'
                            or comment ilike  '%appcode%'
                            or comment ilike  '%codeanywhere%'
                            or comment ilike  '%eclipse%'
                            or comment ilike  '%intellij%'
                            or comment ilike  '%netbeans%'
                            or comment ilike  '%pycharm%'
                            or comment ilike  '%xcode%'
                            or comment ilike  '%third party%'
                            or comment ilike  '%3rd party%'
                            or comment ilike  '%readme%'
                            or comment ilike  '%rename%'
                            or comment ilike  '%681%'
                            or comment ilike  '%589%'
                            or comment ilike  '%hook%'
                            or comment ilike  '%2415%'
                            or comment ilike  '%5658%'
                            or comment ilike  '%api%'
                            or comment ilike  '%snippet%'
                            or comment ilike  '%code review%'
                            or comment ilike  '%gerrit%'
                            or comment ilike  '%highlight%'
                            or comment ilike  '%side%by%side%'
                            or comment ilike  '%diff%view%'
                            or comment ilike  '%white%space%'
                            or comment ilike  '%large file%'
                            or comment ilike  '%binary%'
                            or comment ilike  '%lfs%'
                            or comment ilike  '%asset%'
                            or comment ilike  '%2fa%'
                            or comment ilike  '%two factor%'
                            or comment ilike  '%2 factor%'
                            or comment ilike  '%overview%'
                            or comment ilike  '%dashboard%'
                            or comment ilike  '%7928%'
                            or comment ilike  '%report%'
                            or comment ilike  '%graph%'
                            or comment ilike  '%stat%'
                            or comment ilike  '%contribut%'
                            or comment ilike  '%issue track%'
                            or comment ilike  '%issue mana%'
                            or comment ilike  '%bug track%'
                            or comment ilike  '%task mana%'
                            or comment ilike  '%ticket%'
                            or comment ilike  '%jira%'
                            or comment ilike  '%sourcetree%'
                            or comment ilike  '%CD%'
                            or comment ilike  '%CI%'
                            or comment ilike  '%codeship%'
                            or comment ilike  '%travis%'
                            or comment ilike  '%teamcity%'
                            or comment ilike  '%continuous int%'
                            or comment ilike  '%continuous delivery%'
                            or comment ilike  '%8548%'
                            or comment ilike  '%organiz%'
                            or comment ilike  '%repo%'
                            or comment ilike  '%group%'
                            or comment ilike  '%manage%'
                            or comment ilike  '%tag%'
                            or comment ilike  '%label%'
                            or comment ilike  '%index%'
                            or comment ilike  '%project%'
                            or comment ilike  '%browse%'
                            or comment ilike  '%browse%')) then 1 else 0 end as Functionality
                            
                            
                            from nps)
                            
                            select comment
                            from ruf
                            where comment is not null and char_length(comment)>20
                            and comment not ilike '%;%'
                            and comment not in (select comment from ccarter.nlp_trainer where classification ilike '%f%')
                            limit 50;")



Sys.sleep(10)

ui <- fluidPage(useShinyjs(),extendShinyjs(text=jsResetCode),fluidRow(column(3, verbatimTextOutput("value"))),pageWithSidebar(
  
  headerPanel("RUF Training Survey v1.0"),
  sidebarPanel(
    h6(textOutput("save.results")),
    selectInput("selectName", label = h3("Select User"), 
                choices = list("Chris Carter" = "Chris Carter", "Sean Cramer" = "Sean Cramer", "Stephen George" = "Stephen George", "Erika Sa" = "Erika Sa", "Alyjan Daya" = "Alyjan Daya"), 
                selected = "Chris Carter"),
    selectInput("select", label = h3("Select Classification"), 
                choices = list("Reliability" = 1, "Usability" = 2, "Functionality" = 3), 
                selected = 1),
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
    ),
  mainPanel(
    uiOutput("MainAction"),
#     plotOutput("gamePlot"),
    conditionalPanel(
      condition="input.select==1",
        checkboxGroupInput("checkGroupR", label = h3("Classify these!"), choices = lapply(1:nrow(dfR), function(i){dfR[i,1]}))
      

    ),
    rm(list="dfR"),
    conditionalPanel(
      condition="input.select==2",
        checkboxGroupInput("checkGroupU", label = h3("Classify these!"), choices =lapply(1:nrow(dfU), function(i){dfU[i,1]}))


    ),
    rm(list="dfU"),
    conditionalPanel(
      condition="input.select==3",
        checkboxGroupInput("checkGroupF", label = h3("Classify these!"), choices =lapply(1:nrow(dfF), function(i){dfF[i,1]}))
    ),
    rm(list="dfF")
    )
  )
)
server <- function(input, output) {
  output$MainAction <- renderUI( {
    dynamicUi()
  })
  dynamicUi <- reactive({
    if (input$submit==0) 
      return(
        list(
          h5("Welcome to RUF Classification!"),
          h6("by VoC")
        )
      )
    if (input$submit>0)
      return(
        list(
          h4("Thanks helping us train the NBC!"),
          br()
        )
      )    
  })
  
  output$value <- renderPrint({
    if (input$submit>0) {
      cat("Processing Reliability...")
      cat('\n')
      commentsR<-c(input$checkGroupR)
      commentsU<-c(input$checkGroupU)
      commentsF<-c(input$checkGroupF)
      name<-input$selectName
      for (i in commentsR)
      {
          i<-gsub("'","",i)
          query<-paste("insert into ccarter.nlp_trainer values(CURRENT_DATE,'",name,"','",i,"','r');",sep='')
          CacheOrQueryRedshift(query)
          rm(list="query")
      }
      cat("Done with Reliability")
      cat('\n')
      cat("Processing Usability...")
      for (i in commentsU)
      {
        i<-gsub("'","",i)
        query<-paste("insert into ccarter.nlp_trainer values(CURRENT_DATE,'",name,"','",i,"','u');",sep='')
        CacheOrQueryRedshift(query)
        rm(list="query")
      }
      cat('\n')
      cat("Done with Usability")
      cat('\n')
      cat("Processing Functionality...")
      for (i in commentsF)
      {
        i<-gsub("'","",i)
        query<-paste("insert into ccarter.nlp_trainer values(CURRENT_DATE,'",name,"','",i,"','f');",sep='')
        CacheOrQueryRedshift(query)
        rm(list="query")
      }
      cat('\n')
      cat('Done')
     
    }
  })
#   output$gamePlot <- renderPlot({
#     # Render a barplot
#     if (input$submitF>0 || input$submit>0 || input$submitU>0){
#     queryR<-paste("select count(*) from ccarter.nlp_trainer where username ilike '%",input$selectName,"%' and classification ilike '%r%';",sep='')
#     queryU<-paste("select count(*) from ccarter.nlp_trainer where username ilike '%",input$selectName,"%' and classification ilike '%u%';",sep='')
#     queryF<-paste("select count(*) from ccarter.nlp_trainer where username ilike '%",input$selectName,"%' and classification ilike '%f%';",sep='')
#     r<-CacheOrQueryRedshift(queryR)
#     u<-CacheOrQueryRedshift(queryU)
#     f<-CacheOrQueryRedshift(queryF)
#     x1<-r[,1]
#     x2<-u[,1]
#     x3<-f[,1]
#     y<-c(x1,x2,x3)
#     yLimit<-x1+x2+x3
#     cols<-c("red","blue","green")
#     barplot(y, main="Comments Classified",names.arg=c("R","U","F"),col=cols, ylim = c(0,yLimit))
#     rm(list="queryR")
#     rm(list="queryU")
#     rm(list="queryF")
#     }
#   })
  observeEvent(input$reset, {js$reset()})
}
shinyApp(ui = ui, server = server)
