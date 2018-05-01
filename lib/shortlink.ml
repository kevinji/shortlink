open! Core
open! Async
open Cohttp
open Cohttp_async

module Entry = struct
  type t =
    { dest_url      : Uri.t
    ; creation_time : Time_ns.t
    } [@@deriving sexp]
end

type t = Entry.t String.Map.t [@@deriving sexp]

let sample () =
  String.Map.of_alist_exn
    [ ("/cal", { Entry.
                 dest_url = Uri.of_string "https://www.berkeley.edu/"
               ; creation_time = Time_ns.now ()
               })
    ; ("/git", { Entry.
                 dest_url = Uri.of_string "https://github.com/mc10"
               ; creation_time = Time_ns.now ()
               })
    ]

let server ~port ~shortlinks =
  let handler ~body address request =
    let in_path = Request.uri request |> Uri.path in
    match Map.find shortlinks in_path with
    | None ->
      Server.respond (Code.status_of_code 404)
    | Some shortlink ->
      Server.respond_with_redirect shortlink.Entry.dest_url
  in
  let where_to_listen = Tcp.Where_to_listen.of_port port in
  Server.create ~on_handler_error:`Raise where_to_listen handler
