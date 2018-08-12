# [digital-asset-liquidation](https://github.com/rapsealk/digital-asset-liquidation) API Document

## Accounts
### POST /accounts/create
- request
```
~@Header~
~@Query~
~@Body~
```
- response
```
{
    "succeed": true,
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB"
}
```
### GET /accounts/balance[/ether]
- request
```
~@Header~
@Query
{
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB"
}
~@Body~
```
- response
```
{
    "succeed": true,
    "balance": 100
}
```
### POST /accounts/airdrop
- request
```
~@Header~
~@Query~
@Body
{
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB"
}
```
- response
```
{
    "succeed": true,
    "balance": 100
}
```
### GET /asset
- request
```
~@Header~
@Query
{
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB",
    "id": 1531840123360
}
~@Body~
```
- response
```
{
    "succeed": true,
    "asset": {
        "id": 1531840123360,
        "owner": "0xF04bcA26F82038b6590E58291a957485Df73C2CB",
        "price": 10000000,
        "totalShare": 100,
        "owningShare": 100,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/hanium-2018.appspot.com/o/asset%2FniZ4G8TKf2cwTu5QVPpPlrwwNl73%2F1531840123360?alt=media&token=ab23358f-e98b-4f0d-aa0a-3a3bb5b1e178"
    }
}
```
### GET /assets
- request
```
~@Header~
@Query
{
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB"
}
~@Body~
```
- response
```
{
    "succeed": true,
    "assets": [
        {
            "id": 1531840123360,
            "owner": "0xF04bcA26F82038b6590E58291a957485Df73C2CB",
            "price": 10000000,
            "totalShare": 100,
            "owningShare": 100,
            "imageUrl": "https://firebasestorage.googleapis.com/v0/b/hanium-2018.appspot.com/o/asset%2FniZ4G8TKf2cwTu5QVPpPlrwwNl73%2F1531840123360?alt=media&token=ab23358f-e98b-4f0d-aa0a-3a3bb5b1e178"
        }
    ]
}
```
### POST /assets/register
- request
```
~@Header~
~@Query~
@Body
{
    "address": "0xF04bcA26F82038b6590E58291a957485Df73C2CB",
    "assetId": 1531840123360
}
```
- response
```
{
    "succeed": true
}
```
### POST /assets/trade
- request
```
~@Header~
~@Query~
@Body
{
    "address": "0xA2d16E7eA51D41446812924fa31172D3ECe99E31",
    "owner": "0xF04bcA26F82038b6590E58291a957485Df73C2CB",
    "id": 1531840123360,
    "amount": 10
}
```
- response
```
{
    "succeed": true,
    "balance": 10
}
```