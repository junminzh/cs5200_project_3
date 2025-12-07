#ifndef __MEM_CACHE_REPLACEMENT_POLICIES_MR_CLEAN_RP_HH__
#define __MEM_CACHE_REPLACEMENT_POLICIES_MR_CLEAN_RP_HH__

#include "mem/cache/replacement_policies/base.hh"

namespace gem5
{

struct MrCleanRPParams;

namespace replacement_policy
{

class MrClean : public Base
{
  protected:
    /** MrClean-specific implementation of replacement data. */
    struct MrCleanReplData  : ReplacementData
    {
        /** Tick on which the entry was last touched. */
        Tick lastTouchTick;
        /** Whether this block is considered dirty (approximated). */
        bool isDirty;
        /** Default constructor. Invalidate data. */
        MrCleanReplData() : lastTouchTick(0), isDirty(false) {}
    };

  public:
    typedef MrCleanRPParams Params;
    MrClean(const Params &p);
    ~MrClean() = default;

    /**
     * Invalidate replacement data to set it as the next probable victim.
     * Sets its last touch tick as the starting tick.
     *
     * @param replacement_data  Replacement data to be invalidated.
     */
    void invalidate(const std::shared_ptr<ReplacementData>& replacement_data) override;

    /**
     * Touch an entry to update its replacement data.
     * Sets its last touch tick as the current tick.
     * Updates dirty status based on packet type.
     *
     * @param replacement_data  Replacement data to be touched.
     * @param pkt               Packet that generated this access.
     */
    void touch(const std::shared_ptr<ReplacementData>& replacement_data, const PacketPtr pkt) override;
    void touch(const std::shared_ptr<ReplacementData>& replacement_data) const override;

    /**
     * Reset replacement data. Used when an entry is inserted.
     * Sets its last touch tick as the current tick.
     *
     * @param replacement_data Replacement data to be reset.
     * @param pkt Packet that generated this access.
     */
    void reset(const std::shared_ptr<ReplacementData>& replacement_data, const PacketPtr pkt) override;
    void reset(const std::shared_ptr<ReplacementData>& replacement_data) const override;

    /**
     * Find replacement victim using MrClean policy.
     * Prefers dirty blocks over clean blocks.
     * Among blocks of the same type, uses LRU.
     *
     * @param candidates Replacement candidates, selected by indexing policy.
     * @return Replacement entry to be replaced.
     */
    ReplaceableEntry* getVictim(const ReplacementCandidates& candidates) const override;

    /**
     * Instantiate a replacement data entry.
     *
     * @return A shared pointer to the new replacement data.
     */
    std::shared_ptr<ReplacementData> instantiateEntry() override;
};

} // namespace replacement_policy
} // namespace gem5

#endif // __MEM_CACHE_REPLACEMENT_POLICIES_MR_CLEAN_RP_HH__
