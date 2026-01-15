/**
 * CoinsExtra API Worker
 * ---------------------
 * This is the single entry point for the Cloudflare Worker.
 * Wrangler loads this file based on `main` in wrangler.toml.
 */

export interface Env {
  /**
   * D1 database binding.
   * This name MUST exactly match wrangler.toml:
   *
   * [[d1_databases]]
   * binding = "coinsextra_db"
   */
  coinsextra_db: D1Database;
}

export default {
  /**
   * Cloudflare Workers entry point.
   * Every HTTP request enters this function.
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
         * No joins yet — raw account rows only.
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
         * Catch any database or runtime errors
         * and return them clearly for debugging
         */
        return new Response(
          JSON.stringify({
            error: "Failed to fetch accounts",
            details: String(error),
          }),
          {
            status: 500,
            headers: { "Content-Type": "application/json" },
          }
        );
      }
    }

    /**
     * ROUTE: GET /users
     *
     * Purpose:
     * - Fetch all users
     * - Confirms users table exists and is readable
     */
    if (url.pathname === "/users" && request.method === "GET") {
      const { results } = await env.coinsextra_db
        .prepare(
          `
          SELECT
            user_id,
            email,
            display_name,
            created_at
          FROM users
          `
        )
        .all();

      return new Response(JSON.stringify(results, null, 2), {
        headers: { "Content-Type": "application/json" },
      });
    }

    /**
     * ROUTE: GET /users/:user_id/accounts
     *
     * Purpose:
     * - Fetch all accounts owned by a specific user
     * - Demonstrates dynamic routing + parameter binding
     */
    const userAccountsMatch =
      url.pathname.match(/^\/users\/([^/]+)\/accounts$/);

    if (userAccountsMatch && request.method === "GET") {
      const userId = userAccountsMatch[1];

      const { results } = await env.coinsextra_db
        .prepare(`SELECT * FROM accounts WHERE user_id = ?`)
        .bind(userId)
        .all();

      return new Response(JSON.stringify(results, null, 2), {
        headers: { "Content-Type": "application/json" },
      });
    }

    /**
     * FALLBACK: 404 Not Found
     *
     * If no routes match, return a clean 404.
     */
    return new Response(
      JSON.stringify({ error: "Not Found" }),
      {
        status: 404,
        headers: { "Content-Type": "application/json" },
      }
    );
  },
};

    

