import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purdue eHealth EMS Daily Survey',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last Updated: 2022-09-09',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Information Collection and Use',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to health info, name. The information that we request will be retained by us and used as described in this privacy policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              '1.1 Health Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'The health information provided is strictly maintained in accordance with HIPAA and will not be shared with any other parties. It is used solely to allow paramedics to assess your current health and offer the best care.',
            ),
            SizedBox(height: 8.0),
            Text(
              'The data is kept secure within a HIPAA-compliant database and will be deleted after the client exits our program or wishes to no longer participate in our community paramedicine program.',
            ),
            SizedBox(height: 16.0),
            Text(
              '1.2 Third-Party Services',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'The app does use third-party services that may collect information used to identify you.',
            ),
            SizedBox(height: 8.0),
            Text(
              'Link to the privacy policy of third-party service providers used by the app:',
            ),
            SizedBox(height: 8.0),
            Text(
              '- Google Play Services',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Log Data',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We want to inform you that whenever you use our Service, in case of an error in the app, we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Cookies',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.',
            ),
            SizedBox(height: 8.0),
            Text(
              'This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Service Providers',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may employ third-party companies and individuals due to the following reasons:',
            ),
            SizedBox(height: 8.0),
// Use a Column or ListView to display bullet points
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.check),
                  title: Text('To facilitate our Service'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.check),
                  title: Text('To provide the Service on our behalf'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.check),
                  title: Text('To perform Service-related services'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.check),
                  title: Text('To assist us in analyzing how our Service is used'),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
                'We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Security',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.'
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Links to Other Sites',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Children’s Privacy',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions'
            ),
            SizedBox(height: 16.0),
            Text(
              '8. Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.'
            ),
            SizedBox(height: 8.0),
            Text(
                'This policy is effective as of 2022-09-09'
            ),
          ],
        ),
      ),
    );
  }
}