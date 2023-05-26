use anyhow::Result;
use spin_sdk::{
    http::{Params, Request, Response, Router},
    http_component,
    key_value::Store,
};

#[http_component]
fn handle_cosmos_showcase(req: Request) -> Result<Response> {
    let mut router = Router::default();
    
    router.post(":key", set_value);
    router.get("/:key", get_value);
    router.handle(req)
}

/// handler to get the value at key from the store
/// if the key does not exist, it returns a 404
fn get_value(_req: Request, params: Params) -> Result<Response> {
    let store = Store::open_default()?;
    let Some(key) = params.get("key") else {
        return bad_request();
    };
    match store.exists(key) {
        Ok(true) => (),
        Ok(false) => {
            return Ok(http::Response::builder()
                .status(http::StatusCode::NOT_FOUND)
                .body(None)?)
        }
        Err(_) => return err()
    }
    match store.get(key) {
        Ok(value) => Ok(http::Response::builder()
            .status(http::StatusCode::OK)
            .body(Some(value.into()))?),
        Err(_) => err(),
    }
}

/// Handler to store a value in key-value store
fn set_value(req: Request, params: Params) -> Result<Response> {
    let store = Store::open_default()?;
    let Some(key) = params.get("key") else {
        return bad_request()
    };
    match store.set(key, req.body().as_deref().unwrap_or(&[])) {
        Ok(_) => Ok(http::Response::builder()
            .status(http::StatusCode::OK)
            .body(None)?),
        Err(_) => err(),
    }
}

/// helper function to quickly return a bad request HTTP Response
fn bad_request() -> Result<Response> {
    Ok(http::Response::builder()
        .status(http::StatusCode::BAD_REQUEST)
        .body(None)?)
}

/// helper function to quickly return an internal server error HTTP Response
fn err() -> Result<Response> {
    Ok(http::Response::builder()
        .status(http::StatusCode::INTERNAL_SERVER_ERROR)
        .body(None)?)
}
