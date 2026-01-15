/**
 * CoinsExtra API Worker
 * ---------------------
 * This is the entry point for the Cloudflare Worker.
 * Wrangler loads this file based on `main` in wrangler.toml.
 */
export interface Env {
  /**
   * This binding name MUST match wrangler.toml:
   * binding = "coinsextra_db"
   */
  coinsextra_db: D1Database;
}

export default {
  /**
   * Cloudflare Workers entry point.
   * Every HTTP request enters here.
   */
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    /**
     * ROUTE: GET /accounts
     *
     * Purpose:
     * - Fetch all accounts from the D1 database
     * - Used to verify DB connectivity
     * - First real API endpoint
     */
    if (url.pathname === "/accounts" && request.method === "GET") {
      try {
        /**
         * Simple SQL query.
         * No joins yet — just raw account rows.
         */
        const { results } = await env.coinsextra_db
          .prepare(`SELECT * FROM accounts`)
          .all();

        /**
         * Return JSON with correct headers
         */
        return new Response(JSON.stringify(results, null, 2), {
          headers: { "Content-Type": "application/json" },
        });
      } catch (error) {
        /**
         * Any database or runtime error
         * is returned clearly for debugging
         */
        return new Response(
          JSON.stringify({
            error: "Failed to fetch accounts",
            details: String(error),
          }),
          { status: 500 }
        );
      }
    }

    /**
     * Fallback route
     */
    return new Response("Not Found", { status: 404 });
  },
};


