#!/usr/bin/env python3
"""
==============================================================================
LICENSE KEY GENERATOR (SERVER-SIDE ONLY)
AI Workflow Rules Framework v5.0
==============================================================================

PURPOSE:
    Generate secure, unique license keys for AI Workflow Rules customers

USAGE:
    python scripts/generate-license.py
    python scripts/generate-license.py --count 10
    python scripts/generate-license.py --customer "Company Name"
    python scripts/generate-license.py --export keys.txt

WHAT IT DOES:
    1. Generates cryptographically secure license keys
    2. Format: AWRF-XXXX-XXXX-XXXX-XXXX
    3. HMAC signature for validation (prevents counterfeiting)
    4. Optionally exports to database or file

SECURITY:
    - Uses secrets module (CSPRNG)
    - HMAC-SHA256 for integrity
    - Secret key must be stored securely (env var or secrets manager)
    - DO NOT commit generated keys to git!

NOTE:
    This is for INTERNAL USE ONLY by license administrators.
    Customers should NEVER run this script.

==============================================================================
"""

import secrets
import hmac
import hashlib
import json
import sys
from datetime import datetime, timezone
from typing import Dict, List

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Secret key for HMAC signing
# CRITICAL: Store this securely (e.g., AWS Secrets Manager, environment variable)
# DO NOT hardcode in production! This is just an example.
SECRET_KEY = "YOUR_SECRET_KEY_HERE_CHANGE_IN_PRODUCTION_USE_ENV_VAR"

# License key format
PREFIX = "AWRF"
SEGMENT_LENGTH = 4
NUM_SEGMENTS = 4

# ==============================================================================
# LICENSE KEY GENERATION
# ==============================================================================

def generate_random_segment(length: int = 4) -> str:
    """Generate a random alphanumeric segment."""
    alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"  # Exclude similar chars: I,O,0,1
    return ''.join(secrets.choice(alphabet) for _ in range(length))


def calculate_checksum(key_without_checksum: str, secret: str) -> str:
    """
    Calculate HMAC-SHA256 checksum for license key validation.

    This allows server-side verification without database lookup.
    The last segment contains a checksum derived from the first 3 segments.
    """
    message = key_without_checksum.encode('utf-8')
    secret_bytes = secret.encode('utf-8')

    signature = hmac.new(secret_bytes, message, hashlib.sha256).hexdigest()

    # Use first 4 characters of hex signature, convert to our alphabet
    checksum_hex = signature[:4]
    checksum_int = int(checksum_hex, 16)

    # Convert to base32-like (our restricted alphabet)
    alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    checksum = ""
    for _ in range(SEGMENT_LENGTH):
        checksum = alphabet[checksum_int % len(alphabet)] + checksum
        checksum_int //= len(alphabet)

    return checksum


def generate_license_key(secret: str = SECRET_KEY) -> str:
    """
    Generate a complete license key with checksum.

    Format: AWRF-XXXX-XXXX-XXXX-CCCC
    Where CCCC is HMAC checksum of previous segments

    Returns:
        str: License key in format AWRF-XXXX-XXXX-XXXX-XXXX
    """
    # Generate 3 random segments
    segments = [
        generate_random_segment(SEGMENT_LENGTH)
        for _ in range(NUM_SEGMENTS - 1)
    ]

    # Create key without checksum
    key_without_checksum = f"{PREFIX}-" + "-".join(segments)

    # Calculate checksum for last segment
    checksum = calculate_checksum(key_without_checksum, secret)
    segments.append(checksum)

    # Complete key
    license_key = f"{PREFIX}-" + "-".join(segments)

    return license_key


def verify_license_key(license_key: str, secret: str = SECRET_KEY) -> bool:
    """
    Verify a license key's checksum.

    This can be done server-side without database lookup.

    Args:
        license_key: License key to verify
        secret: Secret key used for HMAC

    Returns:
        bool: True if valid, False otherwise
    """
    # Split key into segments
    parts = license_key.split('-')

    if len(parts) != NUM_SEGMENTS + 1:  # PREFIX + 4 segments
        return False

    if parts[0] != PREFIX:
        return False

    # Reconstruct key without last segment (checksum)
    key_without_checksum = f"{parts[0]}-{parts[1]}-{parts[2]}-{parts[3]}"
    expected_checksum = calculate_checksum(key_without_checksum, secret)
    actual_checksum = parts[4]

    return hmac.compare_digest(expected_checksum, actual_checksum)


# ==============================================================================
# LICENSE RECORD GENERATION
# ==============================================================================

def create_license_record(
    license_key: str,
    customer_name: str = None,
    customer_email: str = None,
    license_type: str = "proprietary",
    notes: str = None
) -> Dict:
    """
    Create a complete license record for database storage.

    Args:
        license_key: Generated license key
        customer_name: Customer/company name
        customer_email: Customer email
        license_type: Type of license
        notes: Additional notes

    Returns:
        dict: License record with metadata
    """
    now = datetime.now(timezone.utc)

    return {
        "license_key": license_key,
        "customer_name": customer_name,
        "customer_email": customer_email,
        "license_type": license_type,
        "issued_date": now.isoformat(),
        "expiration_date": None,  # Perpetual license
        "version": "4.0",
        "status": "active",
        "max_activations": 1,  # Single user/org
        "notes": notes,
        "created_at": now.isoformat(),
        "created_by": "license_generator",
    }


# ==============================================================================
# BATCH GENERATION
# ==============================================================================

def generate_batch(count: int, customer_prefix: str = None) -> List[Dict]:
    """
    Generate multiple license keys.

    Args:
        count: Number of keys to generate
        customer_prefix: Optional prefix for customer names (e.g., "Customer")

    Returns:
        list: List of license records
    """
    licenses = []

    for i in range(count):
        key = generate_license_key()

        customer_name = None
        if customer_prefix:
            customer_name = f"{customer_prefix} #{i+1}"

        record = create_license_record(
            license_key=key,
            customer_name=customer_name,
            notes=f"Batch generated, key {i+1} of {count}"
        )

        licenses.append(record)

    return licenses


# ==============================================================================
# EXPORT FUNCTIONS
# ==============================================================================

def export_to_json(licenses: List[Dict], filename: str = "licenses.json"):
    """Export licenses to JSON file."""
    with open(filename, 'w') as f:
        json.dump(licenses, f, indent=2)
    print(f"✅ Exported {len(licenses)} licenses to {filename}")


def export_to_text(licenses: List[Dict], filename: str = "licenses.txt"):
    """Export license keys only to text file (for distribution)."""
    with open(filename, 'w') as f:
        f.write("AI Workflow Rules License Keys\n")
        f.write("=" * 50 + "\n")
        f.write(f"Generated: {datetime.now().isoformat()}\n")
        f.write("=" * 50 + "\n\n")

        for i, lic in enumerate(licenses, 1):
            f.write(f"{i}. {lic['license_key']}\n")
            if lic.get('customer_name'):
                f.write(f"   Customer: {lic['customer_name']}\n")
            f.write("\n")

    print(f"✅ Exported {len(licenses)} license keys to {filename}")


def export_to_csv(licenses: List[Dict], filename: str = "licenses.csv"):
    """Export licenses to CSV file."""
    import csv

    fieldnames = [
        "license_key", "customer_name", "customer_email",
        "issued_date", "status", "version"
    ]

    with open(filename, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()

        for lic in licenses:
            row = {k: lic.get(k, "") for k in fieldnames}
            writer.writerow(row)

    print(f"✅ Exported {len(licenses)} licenses to {filename}")


# ==============================================================================
# DATABASE INTEGRATION (Example)
# ==============================================================================

def save_to_database(licenses: List[Dict]):
    """
    Save licenses to database.

    This is a placeholder. In production, integrate with your database:
    - PostgreSQL
    - MySQL
    - MongoDB
    - Firebase
    - etc.
    """
    print("⚠️  Database integration not implemented")
    print("   Implement this function to save to your database")
    print(f"   Would save {len(licenses)} licenses")

    # Example PostgreSQL integration:
    # import psycopg2
    # conn = psycopg2.connect(DATABASE_URL)
    # cursor = conn.cursor()
    # for lic in licenses:
    #     cursor.execute(
    #         "INSERT INTO licenses (license_key, customer_name, ...) VALUES (%s, %s, ...)",
    #         (lic['license_key'], lic['customer_name'], ...)
    #     )
    # conn.commit()
    # cursor.close()
    # conn.close()


# ==============================================================================
# CLI INTERFACE
# ==============================================================================

def print_help():
    """Print usage help."""
    print("""
AI Workflow Rules - License Key Generator

Usage:
    python generate-license.py [OPTIONS]

Options:
    --count N              Generate N license keys (default: 1)
    --customer NAME        Customer name
    --email EMAIL          Customer email
    --export FILE          Export to file (json, txt, or csv)
    --verify KEY           Verify a license key
    --help                 Show this help

Examples:
    # Generate single key
    python generate-license.py

    # Generate 10 keys
    python generate-license.py --count 10

    # Generate key for specific customer
    python generate-license.py --customer "Acme Corp" --email "admin@acme.com"

    # Generate and export to file
    python generate-license.py --count 5 --export licenses.txt

    # Verify a key
    python generate-license.py --verify AWRF-A1B2-C3D4-E5F6-G7H8

Security Notes:
    - Store SECRET_KEY securely (environment variable or secrets manager)
    - Never commit generated keys to git
    - Keep licenses.json/txt files secure
    - Implement database integration for production use
""")


def main():
    """Main CLI function."""
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate AI Workflow Rules license keys"
    )
    parser.add_argument(
        '--count', type=int, default=1,
        help='Number of keys to generate (default: 1)'
    )
    parser.add_argument(
        '--customer', type=str,
        help='Customer name'
    )
    parser.add_argument(
        '--email', type=str,
        help='Customer email'
    )
    parser.add_argument(
        '--export', type=str,
        help='Export to file (licenses.json, licenses.txt, or licenses.csv)'
    )
    parser.add_argument(
        '--verify', type=str,
        help='Verify a license key'
    )
    parser.add_argument(
        '--database', action='store_true',
        help='Save to database (requires implementation)'
    )

    args = parser.parse_args()

    # Verify key
    if args.verify:
        print(f"Verifying: {args.verify}")
        is_valid = verify_license_key(args.verify)
        if is_valid:
            print("✅ License key is VALID")
            sys.exit(0)
        else:
            print("❌ License key is INVALID")
            sys.exit(1)

    # Generate keys
    print(f"🔐 Generating {args.count} license key(s)...")
    print()

    licenses = []

    for i in range(args.count):
        key = generate_license_key()

        # Verify generated key (sanity check)
        if not verify_license_key(key):
            print(f"❌ ERROR: Generated invalid key: {key}")
            continue

        record = create_license_record(
            license_key=key,
            customer_name=args.customer,
            customer_email=args.email
        )

        licenses.append(record)

        # Print to console
        print(f"License Key #{i+1}:")
        print(f"  Key: {key}")
        if args.customer:
            print(f"  Customer: {args.customer}")
        if args.email:
            print(f"  Email: {args.email}")
        print()

    # Export
    if args.export:
        ext = args.export.split('.')[-1].lower()
        if ext == 'json':
            export_to_json(licenses, args.export)
        elif ext == 'txt':
            export_to_text(licenses, args.export)
        elif ext == 'csv':
            export_to_csv(licenses, args.export)
        else:
            print(f"⚠️  Unknown format: {ext}")
            print("   Defaulting to JSON")
            export_to_json(licenses, "licenses.json")

    # Save to database
    if args.database:
        save_to_database(licenses)

    print()
    print("✅ Generation complete!")
    print()
    print("⚠️  SECURITY REMINDERS:")
    print("   - Store generated keys securely")
    print("   - Never commit to git")
    print("   - Distribute to customers via secure channel")
    print("   - Keep SECRET_KEY confidential")


if __name__ == "__main__":
    # Check if SECRET_KEY is default (warn if not changed)
    if SECRET_KEY == "YOUR_SECRET_KEY_HERE_CHANGE_IN_PRODUCTION_USE_ENV_VAR":
        print("⚠️  WARNING: Using default SECRET_KEY")
        print("   Set SECRET_KEY environment variable or update in script")
        print()

    main()
