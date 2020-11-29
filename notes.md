# Notes

## Create project:

```bash
$ gcloud projects create jarppe-gcp-test
```

```bash
$ gcloud projects describe jarppe-gcp-test
createTime: '2020-11-24T19:16:25.286Z'
lifecycleState: ACTIVE
name: jarppe-gcp-test
parent:
  id: '012345678901'
  type: organization
projectId: jarppe-gcp-test
projectNumber: '012345678901'
```

Set environment `CLOUDSDK_CORE_PROJECT` to created project id (`jarppe-gcp-test`).

Find billing account:

```bash
$ gcloud alpha billing accounts list
ACCOUNT_ID            NAME                OPEN   MASTER_ACCOUNT_ID
...
```

Set selected account id to `BILLING_ACCOUNT` environment.

```bash
$ gcloud beta billing projects link ${CLOUDSDK_CORE_PROJECT} --billing-account=${BILLING_ACCOUNT}
billingAccountName: billingAccounts/xxxxxx-xxxxxx-xxxxxx
billingEnabled: true
name: projects/jarppe-gcp-test/billingInfo
projectId: jarppe-gcp-test
```

Create service-sccount and grant some permissions to it:

```
$ gcloud iam service-accounts create terraform --display-name="Jarppe's Terraform admin account"
Created service account [terraform].
```

Set environment `SA` to `terraform@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com`

```bash
$ gcloud iam service-accounts keys create ~/.config/gcloud/terraform.json --iam-account=${SA} 

gcloud projects add-iam-policy-binding ${PROJECT_ID}                                  \
  --member=serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com             \
  --role=roles/viewer
gcloud projects add-iam-policy-binding ${PROJECT_ID}                             \
  --member=serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com       \
  --role=roles/storage.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID}                             \
  --member=serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com       \
  --role=roles/editor
```


```
$ export CLOUDSDK_CORE_PROJECT=jarppe-gcp-test
```

# Create service account

```
$ gcloud iam service-accounts create gcp-test-sa
Created service account [gcp-test-sa].
```

```
$ gcloud iam service-accounts list
DISPLAY NAME  EMAIL                                                DISABLED
              gcp-test-sa@jarppe-gcp-test.iam.gserviceaccount.com  False
```

# Get service account keys

```
$ gcloud iam service-accounts keys create key.json --iam-account gcp-test-sa@jarppe-gcp-test.iam.gserviceaccount.com
created key [0365cc75d748abdaf7930d5870add7242f19b0d6] of type [json] as [key.json] for [gcp-test-sa@jarppe-gcp-test.iam.gserviceaccount.com]
```

```
$ cat key.json
{
  "type": "service_account",
  "project_id": "jarppe-gcp-test",
  "private_key_id": "0365cc75d748abdaf7930d5870add7242f19b0d6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkq
  ...
```

# Terraform init

```terraform
provider "google" {
  credentials = file("key.json")
  project     = "jarppe-gcp-test"
  region      = "europe-north1"
}
```

```bash
$ terraform init
```

Folder `./.terraform` created.

```bash
$ gcloud compute images list | grep debian
debian-10-buster-v20201112                            debian-cloud         debian-10                                     READY
debian-9-stretch-v20201112                            debian-cloud         debian-9                                      READY
```
