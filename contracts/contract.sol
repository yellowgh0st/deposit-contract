pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice This is the deposit contract interface.
interface IDepositContract {
    /// @notice A processed deposit event.
    event DepositEvent(
        bytes pubkey,
        uint256 amount,
				uint256 timestamp,
        uint64 index
    );

    /// @notice Submit a DepositData object.
    /// @param pubkey A Ed25519 public key.
    /// @param deposit_amount Deposit token amount.
    /// Used as a protection against malformed input.
    function deposit(
        bytes calldata pubkey,
        uint deposit_amount
    ) external;

    /// @notice Transfer token amount to address.
    /// @param to_address Target account address.
    /// @param dist_amount Token amount to transfer.
    function distribute(
        address to_address,
        uint dist_amount
    ) external;

    /// @notice Query the current deposit count.
    /// @return The deposit count.
    function get_deposit_count() external view returns (uint64);
}

/// @notice This is the deposit contract interface.
contract DepositContract is AccessControl, ReentrancyGuard, IDepositContract {
    // NOTE: this also ensures `deposit_count` will fit into 64-bits
    uint constant MAX_DEPOSIT_COUNT = 2**32 - 1;
    uint256 deposit_count;
    bytes32 public constant DISTRIBUTOR_ROLE = keccak256("DISTRIBUTOR_ROLE");
    IERC20 public immutable token;

    constructor(address owner, IERC20 _token, address distributor) {
        require(owner != address(0), "DepositContract: owner is zero address");
        require(_token != IERC20(address(0)), "DepositContract: token is zero address");
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(DISTRIBUTOR_ROLE, distributor);
        token = _token;
    }

    function get_deposit_count() override external view returns (uint64) {
        return uint64(deposit_count);
    }

    function deposit(
        bytes calldata pubkey,
        uint256 deposit_amount
    ) override external nonReentrant {
        // Extended ABI length checks since dynamic types are used.
        require(pubkey.length == 56, "DepositContract: invalid pubkey length");

        // Check deposit amount
        require(deposit_amount >= 1, "DepositContract: deposit value too low");
        require(deposit_amount <= type(uint64).max, "DepositContract: deposit value too high");

        token.transferFrom(msg.sender, address(this), deposit_amount);

        // Emit `DepositEvent` log
        emit DepositEvent(
            pubkey,
            uint256(deposit_amount),
						block.timestamp,
            uint64(deposit_count)
        );
        // Avoid overflowing count
        require(deposit_count < MAX_DEPOSIT_COUNT, "DepositContract: reached max deposit count");
        deposit_count += 1;
    }

    function distribute(
        address to_address,
        uint dist_amount
    ) override external nonReentrant onlyRole(DISTRIBUTOR_ROLE) {
        // Check distribution amount
        require(dist_amount > 1, "DepositContract: distribution value too low");
        require(dist_amount <= type(uint64).max, "DepositContract: distribution value too high");
        token.transfer(to_address, dist_amount);
    }
}
