import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:melton_app/constants/constants.dart';
import 'package:melton_app/models/ProfileModel.dart';
import 'package:melton_app/util/social_media.dart';

class ProfileEditSocialMediaItem extends StatelessWidget {
  final SocialMediaAccounts _accounts;

  ProfileEditSocialMediaItem(this._accounts);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SingleSocialMediaEditItem(_accounts, SocialMedia.FACEBOOK_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.INSTAGRAM_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.TWITTER_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.WECHAT_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.LINKEDIN_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.OTHER1_KEY),
          SingleSocialMediaEditItem(_accounts, SocialMedia.OTHER2_KEY),
        ],
      ),
    );
  }
}

class SingleSocialMediaEditItem extends StatelessWidget {
  final SocialMediaAccounts _accounts;
  final String _socialMediaKey;

  SingleSocialMediaEditItem(this._accounts, this._socialMediaKey);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: SocialMedia.getSocialMediaAccount(_accounts, _socialMediaKey),
          autovalidate: true,
          validator: (value) {
            if (value.isNotEmpty && !SocialMedia.isSocialMediaFormatted(_socialMediaKey, value)) {
              return "Start with '" + SocialMedia.KEY_URL_MAP[_socialMediaKey] + "...'";
            }
            return null;
          },
          onSaved: (String newValue) {
            SocialMedia.setSocialMediaAccount(_accounts, _socialMediaKey, newValue);
          },
          maxLength: 60,
          decoration: SocialMedia.getInputDecorationFromKey(_socialMediaKey),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}
