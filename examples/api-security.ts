/**
 * Example: Secure API Route
 *
 * This API route demonstrates security best practices following
 * RULES_CORE.md Section 10 (Security & Quality Guards).
 *
 * ✅ GOOD practices shown here:
 * - Secrets from environment variables (never hardcoded)
 * - Input validation (prevents injection attacks)
 * - Error handling (try/catch)
 * - Rate limiting consideration
 * - CORS properly configured
 * - No sensitive data in logs
 *
 * ❌ BAD practices avoided:
 * - Hardcoded API keys
 * - No input validation
 * - Exposing error details to client
 * - SQL injection vulnerabilities
 */

// ✅ GOOD: Import types for better security
import type { NextRequest } from 'next/server';

interface ChatRequest {
  prompt: string;
  maxTokens?: number;
}

export async function POST(req: NextRequest) {
  try {
    // ✅ GOOD: Get API key from environment (never hardcode!)
    const apiKey = process.env.OPENAI_API_KEY;

    // ✅ GOOD: Validate environment variables
    if (!apiKey) {
      console.error('Missing OPENAI_API_KEY environment variable');
      return new Response(
        JSON.stringify({ error: 'Server configuration error' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    // ✅ GOOD: Parse and validate request body
    let body: ChatRequest;
    try {
      body = await req.json();
    } catch (error) {
      return new Response(
        JSON.stringify({ error: 'Invalid JSON' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // ✅ GOOD: Validate required fields
    if (!body.prompt || typeof body.prompt !== 'string') {
      return new Response(
        JSON.stringify({ error: 'Prompt is required and must be a string' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // ✅ GOOD: Validate input length (prevent abuse)
    if (body.prompt.length > 10000) {
      return new Response(
        JSON.stringify({ error: 'Prompt too long (max 10000 characters)' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // ✅ GOOD: Sanitize input (basic example)
    const sanitizedPrompt = body.prompt.trim();

    // ✅ GOOD: Use validated maxTokens with fallback
    const maxTokens = body.maxTokens && body.maxTokens > 0 && body.maxTokens <= 4000
      ? body.maxTokens
      : 1000;

    // ✅ GOOD: Make API call with secret from env
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}` // ✅ Using env var
      },
      body: JSON.stringify({
        model: 'gpt-4',
        messages: [{ role: 'user', content: sanitizedPrompt }],
        max_tokens: maxTokens
      })
    });

    // ✅ GOOD: Handle API errors
    if (!response.ok) {
      console.error(`OpenAI API error: ${response.status}`);
      // ✅ GOOD: Don't expose internal error details to client
      return new Response(
        JSON.stringify({ error: 'External API error' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const data = await response.json();

    // ✅ GOOD: Return successful response
    return new Response(
      JSON.stringify(data),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          // ✅ GOOD: Set CORS headers if needed
          'Access-Control-Allow-Origin': process.env.ALLOWED_ORIGIN || '*',
          'Access-Control-Allow-Methods': 'POST',
          'Access-Control-Allow-Headers': 'Content-Type'
        }
      }
    );

  } catch (error) {
    // ✅ GOOD: Log error for debugging (but don't expose to client)
    console.error('Unexpected error in chat API:', error);

    // ✅ GOOD: Generic error message to client
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }
}

/**
 * ❌ BAD EXAMPLE (what NOT to do):
 *
 * export async function POST(req: NextRequest) {
 *   // ❌ CRITICAL: Hardcoded API key (will leak in git!)
 *   const apiKey = "sk-ant-1234567890abcdef";
 *
 *   // ❌ No validation - accepts any input
 *   const { prompt } = await req.json();
 *
 *   // ❌ No error handling - crashes on error
 *   const response = await fetch('https://api.openai.com/...', {
 *     headers: { 'Authorization': `Bearer ${apiKey}` }
 *   });
 *
 *   // ❌ Exposes API key in response if error occurs
 *   return Response.json(await response.json());
 * }
 *
 * Problems with bad example:
 * 1. API key hardcoded → will be committed to git → PUBLIC LEAK
 * 2. No input validation → SQL injection / XSS vulnerability
 * 3. No error handling → server crashes, exposes stack traces
 * 4. No rate limiting → abuse/DoS vulnerability
 * 5. Exposes internal errors → information disclosure
 */

/**
 * Additional security considerations:
 *
 * 1. Rate Limiting (not shown in example):
 *    - Use middleware like `express-rate-limit`
 *    - Limit requests per IP/user
 *    - Return 429 Too Many Requests
 *
 * 2. Authentication (not shown in example):
 *    - Verify JWT token from request headers
 *    - Check user permissions
 *    - Return 401 Unauthorized if invalid
 *
 * 3. Input Sanitization:
 *    - Escape HTML/SQL special characters
 *    - Use prepared statements for database queries
 *    - Validate against whitelist, not blacklist
 *
 * 4. Logging:
 *    - Log errors for debugging
 *    - DON'T log sensitive data (API keys, passwords, PII)
 *    - Use structured logging (JSON format)
 *
 * 5. HTTPS Only:
 *    - Always use HTTPS in production
 *    - Set secure cookies (httpOnly, secure flags)
 *    - Enable HSTS header
 */
