#!/bin/bash

# Copyright 2014 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Encodes the environment variables into a Kubernetes secret.

source nrconfig.env
sed -e "s#{{LABELS}}#${LABELS}#g" ./newrelic-config-template.yaml > newrelic-config.yaml
BASE64_ENC=$(echo $API_KEY | base64 | tr -d '\n' )
echo $BASE64_ENC
sed -e "s#{{API_KEY}}#${BASE64_ENC}#g" ./newrelic-secret-template.yaml > newrelic-secret.yaml
