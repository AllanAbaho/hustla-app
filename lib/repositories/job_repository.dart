import 'package:hustla/app_config.dart';
import 'package:hustla/data_model/add_job_response.dart';
import 'package:hustla/data_model/job_response.dart';
import 'package:hustla/data_model/post_job_application_response.dart';
import 'package:hustla/screens/posted_jobs.dart';
import 'package:http/http.dart' as http;
import 'package:hustla/data_model/category_response.dart';
import 'package:hustla/helpers/shared_value_helper.dart';

class JobRepository {
  Future<JobResponse> getJobs(String sector) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/jobs?sector=${sector}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return jobResponseFromJson(response.body);
  }

  Future<JobResponse> postedJobs(postData) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/posted-jobs");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postData);
    return jobResponseFromJson(response.body);
  }

  Future<JobResponse> appliedJobs(postData) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/applied-jobs");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postData);
    return jobResponseFromJson(response.body);
  }

  Future<AddJobResponse> addJob(postData) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/jobs");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postData);
    return addJobResponseFromJson(response.body);
  }

  Future<AddJobResponse> changeJobStatus(postData) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/change-job-status");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postData);
    return addJobResponseFromJson(response.body);
  }

  Future<PostJobApplicationResponse> postJobApplication(postData) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/post-job-application");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postData);
    return postJobApplicationResponseFromJson(response.body);
  }
}
