#!/bin/bash

#STEP="$1"

#echo "$os.matrix"

if [  "$1" = "LINT" ]; then
  
  pylint scedar --exit-zero --reports=y >  pylint-report.txt
  pylintscore=$(awk '$0 ~ /Your code/ || $0 ~ /Global/ {print}' pylint-report.txt | cut -d'/' -f1 | rev | cut -d' ' -f1 | rev)
  echo "::set-output name=pylint-score::$pylintscore"

elif [ "$1" = "TEST" ]; then    # "tests/"

  pytest $2 --cov=scedar -ra --color=yes > pytest.txt
  pytestpass=$(cat pytest.txt | tail -n3 | head -n1 | grep -o '[^ ]*%')
  pytestscore=${pytestpass%\%}
  echo "::set-output name=pytest_score::$pytestscore" 

elif [ "$1" = "BUILD" ]; then

  python setup.py build
  pytestcheck=$"True"
  echo "::set-output name=build_output::True"  
  
elif [ "$1" = 'LICENSE' ]; then
  
 approved  = ['Apache License 2.0' , 'BSD 3-Clause License','BSD 2-Clause License','GNU General Public License',
              'MIT License',  'Mozilla Public License 2.0', 'Common Development and Distribution License', 
              'Eclipse Public License version 2.0']

elif [ "$1" = "GATHER" ]; then
   

   jq -n --arg repo $2 --arg pylintscore $3  --arg license $4  --arg pyversion $5  --arg os $6 \
        '{ 
        
        Github_Repo : "\($repo)", 
        Pylint_score : "\($pylintscore)",    
        License_check : "\($license)",
        Python_version : "\($pyversion)", 
        OS            : "\($os)" 
        
        }'  > "$6"-py"$5".json

    ls
fi

#sudo apt-get install jq
#dpkg -L jq
    
#jq --arg ARG1 ${var1} --arg ARG2 ${var2} 

# must use _ not - for var names in json

#"Build_status" : "$5", \
#"Test_Coverage" : "$6", \
#"Pytest_status" : "$7", \
#"PIP"           : "$8", \
#"Python_version" : "$9", \
#"OS"             : "${10}" }' > full_report.json




#- name: Get run status
#  id: getrunstatus
#  if: always()  # runs  even when a step fails  success() is for  prev step only,, job.status is for all prev steps? 
#  run: |
#     if [ "${{matrix.os}}" = "ubuntu-latest" ] &&  \
#         [ "${{matrix.python-version}}" = "3.5" ] && \
#         [ "${{job.status}}" = "Success"] ]; then
#
#        echo "::set-output name=ubuntu_py35::SUCCESS"
#      else 
#        echo "::set-output name=ubuntu_py35::FAILURE"
#      fi 
