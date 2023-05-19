import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/screens/my_applications.dart';
import 'package:hustla/screens/posted_jobs.dart';
import 'package:hustla/screens/job_sectors.dart';
import 'package:flutter/material.dart';

class Jobs extends StatefulWidget {
  Jobs({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List _categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  getCategories() {
    var _list = [
      {
        "id": 0,
        "name": "Find A Job",
        "banner":
            "https://hrdailyadvisor.blr.com/app/uploads/sites/3/2016/03/BM_JobPosting-1.jpg",
        "description": "Are you currently looking for work?",
        "page": JobSectors(
          title: 'Job Sectors',
          is_finding_job: true,
        )
      },
      {
        "id": 1,
        "name": "Post A Job",
        "banner":
            "https://thumbs.dreamstime.com/b/business-woman-presenting-hire-us-word-white-card-213809712.jpg",
        "description": "Post a job for free with us and access premium talent.",
        "page": JobSectors(
          is_finding_job: false,
          title: 'Job Sectors',
        )
      },
      {
        "id": 9,
        "name": "My Posted Jobs",
        "banner":
            "https://static.euronews.com/articles/stories/07/31/35/36/1440x810_cmsv2_edcf296d-fa5a-5021-abc3-ee21e477cccb-7313536.jpg",
        "description": "Checkout a list of jobs posted by you.",
        "page": PostedJobs(
          title: 'Posted Jobs',
          banner:
              'https://www.betterteam.com/images/betterteam-free-job-posting-sites-5877x3918-20210222.jpg?crop=21:16,smart&width=420&dpr=2',
        )
      },
      {
        "id": 11,
        "name": "My Applications",
        "banner":
            "https://www.aces.edu/wp-content/uploads/2018/09/iStock-921020090.jpg",
        "description": "Find out more about the jobs you have applied to.",
        "page": MyApplications(
          title: 'Job Applications',
          banner:
              'https://www.betterteam.com/images/betterteam-free-job-posting-sites-5877x3918-20210222.jpg?crop=21:16,smart&width=420&dpr=2',
        )
      },
    ];
    setState(() {
      _categories = _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context, widget.title),
            preferredSize: Size(
              DeviceInfo(context).width,
              60,
            )),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: buildBody(context, widget.title, _categories)));
  }
}
